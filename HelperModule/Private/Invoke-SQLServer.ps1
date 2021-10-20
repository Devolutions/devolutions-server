function Invoke-SQLServer {
    param (
        [parameter(HelpMessage = 'Used to set SQL Server to use Integrated security')][switch]$SQLIntegrated,
        [parameter(HelpMessage = 'Used to set SQL Server to use Advanced settings')][switch]$AdvancedDB
    )

    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }
    $SQL = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/ef88f312-606e-4a78-bff9-2177867f7a5b'


    $destination = "$path\SQL-SSEI-Expr.exe"
    $source = $SQL
    try {
        Write-LogEvent 'Downloading SQL Server Express...'
        Start-BitsTransfer $source -Destination $destination
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
    
    if ($AdvancedDB) {
        if ($SQLIntegrated) {
            Install-SQL -SQLIntegrated -AdvancedDB
        } else { Install-SQL -AdvancedDB }
    } else { 
        if ($SQLIntegrated) {
            Install-SQL -SQLIntegrated
        } else { Install-SQL }
    }
}