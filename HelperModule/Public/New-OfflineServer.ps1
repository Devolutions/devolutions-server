function New-OfflineServer {
    param(
        [parameter(Mandatory, HelpMessage = "Format for the Console Version being install. `nFormat: 2021.1.19.0")][ValidatePattern('[2][0][0-9][0-9][.][0-9][.][0-9][0-9][.][0]')][ValidateNotNullOrEmpty()][string]$ConsoleVersion

    )
    #TODO Install Offline Server, work in temp instead of script root use $newPath = Split-Path -Path $Scriptroot -Parent
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    if (!(Test-Path $path)) { New-Item $path -ItemType Directory -Force }
    Write-LogEvent "Checking if $PSScriptRoot\Packages exists" -Output
    $Installer = "Setup.DPS.Console.$ConsoleVersion.exe"
    $zip = "DVLS.Instance.$ConsoleVersion.zip"
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
    if (!(Test-Path $Scriptpath\Start-Me.ps1)) {
        $psI = @'
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs }
import-module $PSScriptRoot\DVLS.HelperModule.psd1
Install-DevolutionsServer
'@
        $psI | Out-File $Scriptpath\Start-Me.ps1
    }
    Compress-Archive -Path $Scriptpath -DestinationPath "$env:HOMEPATH\Desktop"
    Write-LogEvent "Zip was added to $env:HOMEPATH\Desktop" -Output
}