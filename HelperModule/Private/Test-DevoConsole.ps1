function Test-DevoConsole {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $Installer = 'Setup.DPS.Console.exe'
    if (Test-Path $path\$Installer) {
        return $true
    } else { return $false }
}