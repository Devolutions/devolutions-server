function Invoke-SQLServer {
    [CmdletBinding(DefaultParameterSetName = 'SQLAccounts')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'SQLAccounts', Position = 0)]
        [System.Management.Automation.PSCredential]$SQLOwnerAccount,

        [Parameter(ParameterSetName = 'SQLAccounts', Position = 1)]
        [System.Management.Automation.PSCredential]$SQLSchedulerAccount,
    
        [Parameter(ParameterSetName = 'SQLAccounts', Position = 2)]
        [System.Management.Automation.PSCredential]$SQLAppPoolAccount,
        
        [parameter(Mandatory, ParameterSetName = 'Integrated', HelpMessage = 'Used to set SQL Server to use Integrated security', Position = 0)]
        [switch]$SQLIntegrated,

        [parameter(HelpMessage = 'Used for Advanced settings for SQL Server installation')][switch]$AdvancedDB
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
        } else { Install-SQL -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount -AdvancedDB }
    } else { 
        if ($SQLIntegrated) {
            Install-SQL -SQLIntegrated
        } else { Install-SQL -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount }
    }
}