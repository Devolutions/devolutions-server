function New-ResponseFile {
    [CmdletBinding(DefaultParameterSetName = 'Credential')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Credential', Position = 0)]
        [System.Management.Automation.PSCredential]$DatabaseMasterAccount,

        [Parameter(ParameterSetName = 'Credential', Position = 1)]
        [System.Management.Automation.PSCredential]$SchedulerAccount,

        [Parameter(ParameterSetName = 'Credential', Position = 2)]
        [System.Management.Automation.PSCredential]$VaultRunnerAccount,

        [Parameter(Mandatory, HelpMessage = 'Include full format license key from email.')]
        [string]$LicenseKey,

        [Parameter(Mandatory, HelpMessage = 'Devolutions Server account used for  first time login account.')]
        [System.Management.Automation.PSCredential]$DevolutionsAdminAccount,

        [Parameter(Mandatory, HelpMessage = 'Password will be used for backup encryption keys.')]
        [System.Management.Automation.PSCredential]$EncryptionKeysPassword,

        [Parameter(Mandatory, HelpMessage = 'Email that will be stored on Devolutions Server first time login account.')]
        [string]$DevolutionsAdminEmail,

        [Parameter(Mandatory, HelpMessage = 'IE: localhost\SQLEXPRESS')]
        [string]$SqlServerHost,

        [Parameter(HelpMessage = 'Name of that Database that will be created.')]
        [string]$DatabaseName = 'dvls',

        [Parameter(HelpMessage = 'Name of that Devolutions Server that will be shown on the Console.')]
        [string]$ServerName = 'Devolutions Server',

        [Parameter(HelpMessage = 'Will disable HTTPs use on the server. Note: Not recommended for production environments.')]
        [switch]$DisableHttps,

        [Parameter(HelpMessage = 'Will disable Encryption on Config. Note: Not recommended for production environments.')]
        [switch]$DisableConfigEncryption,

        [Parameter(HelpMessage = 'Location backup encryption keys will be stored')]
        [string]$BackupKeysLocation = 'C:\DPS Key Backup\DVLS\',

        [Parameter(HelpMessage = 'Name that will be show on IIS.')]
        [string]$AppPoolName = 'dvls',

        [Parameter(HelpMessage = 'Name that will be use on Webpage.')]
        [string]$WebAppName = 'dvls',

        [Parameter(HelpMessage = 'Location of local Devolutions ZIP for installation.')]
        [string]$ZIPFileLocation = 'null',

        [Parameter(HelpMessage = 'Set Server description.')]
        [string]$ServerDescription = 'null',

        [parameter(Mandatory, ParameterSetName = 'Integrated', Position = 0)]
        [switch]$IntegratedSecurity
    )
    $ZIPFileLocation = ($ZIPFileLocation).Replace('\', '\\')
    $BackupKeysLocation = ($BackupKeysLocation).Replace('\', '\\')
    $SqlServerHost = ($SqlServerHost).Replace('\', '\\')

    if ($PSBoundParameters.ContainsKey('IntegratedSecurity'))
    { $IntSec = $true } else { $IntSec = $false }
    if ($PSBoundParameters.ContainsKey('DisableHttps'))
    { $http = 'true' } else { $http = 'false' }
    if ($PSBoundParameters.ContainsKey('DisableConfigEncryption'))
    { $confEncrypt = 'true' } else { $confEncrypt = 'false' }
    if ($ZIPFileLocation -ne 'null') { $ZIPInstall = '"install-zip": ' + '"' + "$ZIPFileLocation" + '"' + ',' } else { $ZIPInstall = '"install-zip": null,' }
    if ($ServerDescription -ne 'null') { $Description = '"description": ' + '"' + "$ServerDescription" + '"' + ',' } else { $Description = '"description": null,' }

    $path = Split-Path -Path $PSScriptRoot -Parent
    $adminUser = $DevolutionsAdminAccount.GetNetworkCredential().UserName
    $adminPass = $DevolutionsAdminAccount.GetNetworkCredential().Password
    $backuppass = $EncryptionKeysPassword.GetNetworkCredential().Password
    $JSON = "$path\response.json"

    if (!($IntSec)) {
        $DBownerUser = $DatabaseMasterAccount.GetNetworkCredential().UserName
        $DBownerPass = $DatabaseMasterAccount.GetNetworkCredential().Password
        if ($null -eq $SchedulerAccount) {
            $SchedulerUser = $DatabaseMasterAccount.GetNetworkCredential().UserName
            $SchedulerPass = $DatabaseMasterAccount.GetNetworkCredential().Password
        } else {
            $SchedulerUser = $SchedulerAccount.GetNetworkCredential().UserName
            $SchedulerPass = $SchedulerAccount.GetNetworkCredential().Password 
        } 
        if ($null -eq $VaultRunnerAccount) {
            $VaultRunnerUser = $DatabaseMasterAccount.GetNetworkCredential().UserName
            $VaultRunnerPass = $DatabaseMasterAccount.GetNetworkCredential().Password
        } else {
            $VaultRunnerUser = $VaultRunnerAccount.GetNetworkCredential().UserName
            $VaultRunnerPass = $VaultRunnerAccount.GetNetworkCredential().Password
        }
        
        $response = @"
{
"accept-eula": true,
"admin-email": "$DevolutionsAdminEmail",
"admin-password": "$adminPass",
"admin-username": "$adminUser",
"server-name": "$ServerName",
"server-serial-key": "$LicenseKey",
"backup-keys-password": "$backuppass",
"backup-keys-path": "$BackupKeysLocation",
"app-pool-identity-type": "NetworkService",
"app-pool-name": "$AppPoolName",
"database-integrated-security": false,
"database-name": "$DatabaseName",
"appPoolPassword": null,
"app-pool-identity-username": null,
"command": "server install",
"database-console-password": "$DBownerPass",
"database-console-username": "$DBownerUser",
"database-host": "$SqlServerHost",
"database-scheduler-password": "$SchedulerPass",
"database-scheduler-username": "$SchedulerUser",
"database-username": null,
"database-vault-password": "$VaultRunnerPass",
"database-vault-username": "$VaultRunnerUser",
"debug": false,
$Description
"disable-encrypt-config": $confEncrypt,
"disable-https": $http,
"disable-password": true,
"console-pwd": null,
"dps-path": "C:\\inetpub\\wwwroot\\$AppPoolName",
"dps-website-name": "Default Web Site",
$ZIPInstall
"quiet": true,
"scheduler": true,
"service-account": "NetworkService",
"servicePassword": null,
"service-user": null,
"verbose": true,
"web-application-name": "/$WebAppName"
}
"@
        try {
            $response | Out-File $JSON
            Write-LogEvent "Please verify $path\response.json file before continuing, make sure all your info is correct." -Output
            Read-Host -Prompt 'Hit enter to continue...'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    } else {
        $response = @"
{
"accept-eula": true,
"admin-email": "$DevolutionsAdminEmail",
"admin-password": "$adminPass",
"admin-username": "$adminUser",
"server-name": "$ServerName",
"server-serial-key": "$LicenseKey",
"backup-keys-password": "$backuppass",
"backup-keys-path": "$BackupKeysLocation",
"database-integrated-security": true,
"database-name": "$DatabaseName",
"app-pool-identity-type": "NetworkService",
"app-pool-name": "$AppPoolName",
"appPoolPassword": null,
"app-pool-identity-username": null,
"command": "server install",
"console-pwd": null,
"database-console-password": null,
"database-console-username": null,
"database-host": "$SqlServerHost",
"database-scheduler-password": null,
"database-scheduler-username": null,
"database-username": null,
"database-vault-password": null,
"database-vault-username": null,
"debug": false,
$Description
"disable-encrypt-config": $confEncrypt,
"disable-https": $http,
"disable-password": true,
"console-pwd": null,
"dps-path": "C:\\inetpub\\wwwroot\\$AppPoolName",
"dps-website-name": "Default Web Site",
$ZIPInstall
"quiet": true,
"scheduler": true,
"service-account": "NetworkService",
"servicePassword": null,
"service-user": null,
"verbose": true,
"web-application-name": "/$WebAppName"
}
"@
        try {
            $response | Out-File $JSON
            Write-LogEvent "Please verify $path\response.json file before continuing, make sure all your info is correct." -Output
            Read-Host -Prompt 'Hit enter to continue...'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    }
}