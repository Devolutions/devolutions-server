function New-ResponseFile {
    [CmdletBinding(DefaultParameterSetName = 'SQLAccounts')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'SQLAccounts', Position = 0)]
        [System.Management.Automation.PSCredential]$SQLOwnerAccount,

        [Parameter(ParameterSetName = 'SQLAccounts', Position = 1)]
        [System.Management.Automation.PSCredential]$SQLSchedulerAccount,

        [Parameter(ParameterSetName = 'SQLAccounts', Position = 2)]
        [System.Management.Automation.PSCredential]$SQLAppPoolAccount,

        [parameter(Mandatory, ParameterSetName = 'Integrated', Position = 0)]
        [switch]$IntegratedSecurity,

        [parameter(Position = 3, HelpMessage = 'Creation of a recovery kit.')]
        [switch]$CreateRecoveryKit,

        [Parameter(Mandatory, HelpMessage = 'Include full format license key from email.')]
        [string]$LicenseKey,

        [Parameter(Mandatory, HelpMessage = 'Devolutions Server account used for  first time login account.')]
        [System.Management.Automation.PSCredential]$DevolutionsAdminAccount,

        [Parameter(Mandatory, HelpMessage = 'Email that will be stored on Devolutions Server first time login account.')]
        [string]$DevolutionsAdminEmail,

        [Parameter(Mandatory, HelpMessage = 'IE: localhost\SQLEXPRESS')]
        [string]$SqlServerHost,

        [Parameter(Mandatory, HelpMessage = 'The case-sensitive URL that will be accessed in RDM and for the Web interface. IE: https://servername.domain.com/dvls')]
        [string]$AccessURI,

        [Parameter(HelpMessage = 'Name of that Database that will be created.')]
        [string]$DatabaseName = 'dvls',

        [Parameter(HelpMessage = 'Name of that Devolutions Server that will be shown on the Console.')]
        [string]$DevolutionsServerName = 'Devolutions Server',

        [Parameter(HelpMessage = 'Name that will be show on IIS.')]
        [string]$AppPoolName = 'dvls',

        [Parameter(HelpMessage = 'Name that will be use on Webpage.')]
        [string]$WebAppName = 'dvls',

        [Parameter(HelpMessage = 'Location of local Devolutions ZIP for installation.')]
        [string]$ZIPFileLocation = 'null',

        [Parameter(HelpMessage = 'Set Server description.')]
        [string]$DevolutionsServerDescription = 'null'

    )
    dynamicparam {
        # check to see whether the user selected to create a recovery kit
        if ($CreateRecoveryKit) {
            # yes, so create a new dynamic parameter
            $paramDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
            $RecoveryKitPath = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
            $RecoveryKitPass = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
    
            # define the parameter attribute
            $Location = New-Object System.Management.Automation.ParameterAttribute
            $Location.Mandatory = $true
            $Location.HelpMessage = 'Path to where the Recovery Kit will be stored'
            $RecoveryKitPath.Add($Location)
            $Password = New-Object System.Management.Automation.ParameterAttribute
            $Password.Mandatory = $true
            $Password.HelpMessage = 'Password used for your Encryption Keys'
            $RecoveryKitPass.Add($Password)
    
            # compose the dynamic parameters
            $rkpath = 'RecoveryKitPath'
            $dynParam1 = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter($rkpath,
                [string], $RecoveryKitPath)
            $rkpass = 'RecoveryKitPassword'
            $dynParam2 = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter($rkpass,
                [securestring], $RecoveryKitPass)
            $paramDictionary.Add($rkpath, $dynParam1)
            $paramDictionary.Add($rkpass, $dynParam2)
    
            # return the collection of dynamic parameters
            $paramDictionary
        }
    }
        
    end {
        if ($CreateRecoveryKit) {
            $RecoveryKitLocation = $PSBoundParameters.RecoveryKitPath
            $RecoveryKitPassword = $PSBoundParameters.RecoveryKitPassword
            $RecoveryKitLocation = ($RecoveryKitLocation).Replace('\', '\\')
        }
        $ZIPFileLocation = ($ZIPFileLocation).Replace('\', '\\')
        $SqlServerHost = ($SqlServerHost).Replace('\', '\\')

        if ($PSBoundParameters.ContainsKey('IntegratedSecurity'))
        { $IntSec = $true } else { $IntSec = $false }
        if ($PSBoundParameters.ContainsKey('CreateRecoveryKit'))
        { $RecoveryKit = 'true' } else { $RecoveryKit = 'false' }
        if ($ZIPFileLocation -ne 'null') { $ZIPInstall = '"install-zip": ' + '"' + "$ZIPFileLocation" + '"' + ',' } else { $ZIPInstall = '"install-zip": null,' }
        if ($DevolutionsServerDescription -ne 'null') { $Description = '"description": ' + '"' + "$DevolutionsServerDescription" + '"' + ',' } else { $Description = '"description": null,' }

        $path = Split-Path -Path $PSScriptRoot -Parent
        $adminUser = $DevolutionsAdminAccount.GetNetworkCredential().UserName
        $adminPass = $DevolutionsAdminAccount.GetNetworkCredential().Password
        $JSON = "$path\response.json"

        if (!($IntSec)) {
            $DBownerUser = $SQLOwnerAccount.GetNetworkCredential().UserName
            $DBownerPass = $SQLOwnerAccount.GetNetworkCredential().Password
            if ($null -eq $SQLSchedulerAccount) {
                $SchedulerUser = $SQLOwnerAccount.GetNetworkCredential().UserName
                $SchedulerPass = $SQLOwnerAccount.GetNetworkCredential().Password
            } else {
                $SchedulerUser = $SQLSchedulerAccount.GetNetworkCredential().UserName
                $SchedulerPass = $SQLSchedulerAccount.GetNetworkCredential().Password 
            } 
            if ($null -eq $SQLAppPoolAccount) {
                $VaultRunnerUser = $SQLOwnerAccount.GetNetworkCredential().UserName
                $VaultRunnerPass = $SQLOwnerAccount.GetNetworkCredential().Password
            } else {
                $VaultRunnerUser = $SQLAppPoolAccount.GetNetworkCredential().UserName
                $VaultRunnerPass = $SQLAppPoolAccount.GetNetworkCredential().Password
            }
        
            $response = @"
{
"accept-eula": true,
"access-uri": "$AccessURI",
"admin-email": "$DevolutionsAdminEmail",
"admin-password": "$adminPass",
"admin-username": "$adminUser",
"server-name": "$DevolutionsServerName",
"server-serial-key": "$LicenseKey",
"backup-keys-password": "$RecoveryKitPassword",
"backup-keys-path": "$RecoveryKitLocation",
"create-recovery-kit": $RecoveryKit,
"create-recovery-kit-path": "$RecoveryKitLocation",
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
"disable-encrypt-config": false,
"disable-https": false,
"disable-password": true,
"console-pwd": null,
"dps-path": "C:\\inetpub\\wwwroot\\$AppPoolName",
"dps-website-name": "Default Web Site",
$ZIPInstall
"quiet": true,
"scheduler": true,
"service-account": "LocalSystem",
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
"access-uri": "$AccessURI",
"admin-email": "$DevolutionsAdminEmail",
"admin-password": "$adminPass",
"admin-username": "$adminUser",
"server-name": "$DevolutionsServerName",
"server-serial-key": "$LicenseKey",
"backup-keys-password": "$RecoveryKitPassword",
"backup-keys-path": "$RecoveryKitLocation",
"create-recovery-kit": $RecoveryKit,
"create-recovery-kit-path": "$RecoveryKitLocation",
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
"disable-encrypt-config": false,
"disable-https": false,
"disable-password": true,
"console-pwd": null,
"dps-path": "C:\\inetpub\\wwwroot\\$AppPoolName",
"dps-website-name": "Default Web Site",
$ZIPInstall
"quiet": true,
"scheduler": true,
"service-account": "LocalSystem",
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
}