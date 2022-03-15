function Install-IISPrerequisites {
    New-EventSource
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }
    $vnet = Test-Path "$path\NDP48-x86-x64-AllOS-ENU.exe"
    $Rewrite = Test-Path "$path\rewrite_amd64_en-US.msi"
    $AppRequestRouting = Test-Path "$path\requestRouter_amd64.msi"
    if (Test-Network) {
        Install-IISFeatures
        Install-IisUrlRewrite
        Install-IisApplicationRequestRouting
        Install-Net48Core
    } elseif ($vnet -and $Rewrite -and $AppRequestRouting) {
        Install-IISFeatures
        Install-IisUrlRewrite
        Install-IisApplicationRequestRouting
        Install-Net48Core
    } else {
        Write-LogEvent "You are trying to run a script that requires an internet connection and/or are missing files locally to install.`nPlease run New-OfflineServer to create a local zip on a PC with Internet access. " -Output
        Read-Host 'Please hit enter to continue...'
        return
    }
}