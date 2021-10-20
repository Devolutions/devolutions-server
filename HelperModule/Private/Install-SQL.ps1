function Install-SQL {
    param(
        [parameter(HelpMessage = 'Used to set SQL Server to use Integrated security')][switch]$SQLIntegrated,
        [parameter(HelpMessage = 'Used to set SQL Server to use Advanced settings')][switch]$AdvancedDB
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
            New-DatabaseStandard
        }
    } else {
        Write-Output "SQL Server has been installed but missing Database for Devolutions Server installation.`n"
        Write-Output "Please use New-DatabaseAdvanced as there are many configurable options. `nNote: You can use Show-Command New-DatabaseAdvanced to verify options."
    }
}