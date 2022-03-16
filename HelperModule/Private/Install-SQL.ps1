function Install-SQL {
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
    $Installer = 'SQL-SSEI-Expr.exe'
    try {
        Write-LogEvent 'Installing SQL Server Express...'
        Start-Process -FilePath $path\$Installer -Args '/ACTION=INSTALL /IACCEPTSQLSERVERLICENSETERMS /Q' -Verb RunAs -Wait
        Write-LogEvent 'SQL Server Express installed'
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
    try {
        Remove-Item $path\$Installer
        Write-LogEvent "Removing $path\$Installer from $Env:ComputerName"
    } catch [System.Exception] { Write-LogEvent $_ -Errors }

    if (!($AdvancedDB)) {
        if ($SQLIntegrated) {
            New-DatabaseStandard -SQLIntegrated
        } else {
            New-DatabaseStandard -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount
        }
    } elseif ($AdvancedDB) {
        if ($SQLIntegrated) {
            New-DatabaseAdvanced -SQLIntegrated
        } else {
            New-DatabaseAdvanced -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount
        }
    } else {
        Write-Output "SQL Server has been installed but missing Database for Devolutions Server installation.`n"
        Write-Output "Please use New-DatabaseAdvanced as there are many configurable options. `nNote: You can use Show-Command New-DatabaseAdvanced to verify options."
    }
}