function New-OfflineServer {
    param(
        [parameter(Mandatory, HelpMessage = "Format for the Console Version being install. `nFormat: 2021.1.17.0")][ValidatePattern('[2][0][0-9][0-9][.][0-9][.][0-9][0-9][.][0]')][ValidateNotNullOrEmpty()][string]$ConsoleVersion

    )
    #TODO Install Offline Server, need to rework Test-Programs
    $path = "$PSScriptRoot\Packages"
    if (!(Test-Path $path)) { New-Item $path -ItemType Directory -Force }
    Write-LogEvent "Checking if $PSScriptRoot\Packages exists" -Output
    $path = "$PSScriptRoot\Packages"
    $Script:Installer = "Setup.DPS.Console.$ConsoleVersion.exe"
    $Script:zip = "DVLS.Instance.$ConsoleVersion.zip"
    $Console = "https://cdn.devolutions.net/download/$Installer"
    $zipFile = "https://cdn.devolutions.net/download/RDMS/DVLS.$ConsoleVersion.zip"
    if (Test-Programs -packages -ErrorAction:SilentlyContinue) {
        try {
            Write-LogEvent 'Downloading Devolutions Server Console' -Output
            Start-BitsTransfer $Console -Destination $path\$Installer
            Write-LogEvent 'Successfully downloaded Devolutions Server Console' -Output
            Write-LogEvent 'Downloading Devolutions Server Instance zip' -Output
            Start-BitsTransfer -Source $zipFile -Destination $path\$zip
            Write-LogEvent 'Successfully downloaded Devolutions Server Instance zip' -Output
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    }
    if (!(Test-Path $PSScriptRoot\Start-Me.ps1)) {
        $psI = @'
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs }
import-module $PSScriptRoot\DVLS.HelperModule.psd1
Install-DevolutionsServer
'@
        $psI | Out-File $PSScriptRoot\Start-Me.ps1
    }
    Compress-Archive -Path $path -DestinationPath "$env:HOMEPATH\Desktop"
    Write-LogEvent "Zip was added to $env:HOMEPATH\Desktop" -Output
}