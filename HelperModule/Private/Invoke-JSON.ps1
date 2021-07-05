function Invoke-JSON {
    param (
        [parameter(HelpMessage = 'Disables the use of HTTP(s) on your Devolutions Server')][switch]$DisableHttps,
        [parameter()][string]$serialKey = ''
        #[parameter(HelpMessage = 'Enabled if you are planning on using Integrated Security on your Devolutions Server')][switch]$IntegratedSecurity
    )
    #TODO Next step prompt for Domain Identity
    #TODO Next step Integrated on or off
    $Path = $env:TEMP
    $admin = Get-Credential -Message 'Please enter your administrator credentials for your Devolutions Server: Note: This is not an AD account.'
    $backupacc = Get-Credential -Message 'Please enter your administrator email address and a password that will be used for your Backups: '
    $adminUser = $admin.GetNetworkCredential().UserName
    $adminPass = $admin.GetNetworkCredential().Password
    $adminEmail = $backupacc.GetNetworkCredential().UserName
    $backuppass = $backupacc.GetNetworkCredential().Password
    $Script:JSON = "$path\response.json"
    $http = if ($DisableHttps) { 'true' } else { 'false' } 
    #$IntSec = if ($IntegratedSecurity) { 'true' } else { 'false' } 
    $response = @"
{
"accept-eula": true,
"admin-email": "$adminEmail",
"admin-password": "$adminPass",
"admin-username": "$adminUser",
"server-name": "Devolutions Server",
"server-serial-key": "$serialKey",
"backup-keys-password": "$backuppass",
"backup-keys-path": "C:\\DPS Key Backup\\DVLS\\",
"app-pool-identity-type": "NetworkService",
"app-pool-name": "dvls",
"database-integrated-security": true,
"database-name": "DVLS",
"appPoolPassword": null,
"app-pool-identity-username": null,
"command": "server install",
"console-pwd": null,
"database-console-password": null,
"database-console-username": null,
"database-host": "localhost\\SQLEXPRESS",
"database-scheduler-password": null,
"database-scheduler-username": null,
"database-username": null,
"database-vault-password": null,
"database-vault-username": null,
"debug": false,
"description": null,
"disable-encrypt-config": false,
"disable-https": $http,
"disable-password": true,
"dps-path": "C:\\inetpub\\wwwroot\\dvls",
"dps-website-name": "Default Web Site",
"install-zip": null,
"quiet": true,
"scheduler": true,
"service-account": "NetworkService",
"servicePassword": null,
"service-user": null,
"verbose": true,
"web-application-name": "/dvls"
}
"@
    try {
        $response | Out-File $JSON 
        Write-LogEvent "Please verify $path\response.json file before continuing, make sure all your info is correct." -Output
        Read-Host -Prompt 'Hit enter to continue...'
    } catch [System.Exception] { Write-LogEvent $_ -Errors }

}