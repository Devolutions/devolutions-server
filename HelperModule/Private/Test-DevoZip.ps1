function Test-DevoZip {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"

    $Installer = 'DVLS.Instance.zip'
    if (Test-Path $path\$Installer) {
        return $true
    } else { return $false }
}