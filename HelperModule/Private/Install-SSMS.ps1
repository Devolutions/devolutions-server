function Install-SSMS {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $Installer = 'SSMS-Setup-ENU.exe'
    try {
        Write-LogEvent 'Installing SQL Server Management Studio...'
        Start-Process -FilePath "$path\$Installer" -Args '/install /quiet /norestart' -Verb RunAs -Wait
        Write-LogEvent 'SQL Server Management Studio installed'
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
    try {
        Write-LogEvent "Removing $path\$Installer from $Env:ComputerName"
        Remove-Item "$path\$Installer"
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
}