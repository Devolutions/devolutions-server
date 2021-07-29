function Test-Packages {
    Write-LogEvent "Checking if $PSScriptRoot\Packages exists"
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $vnet = Test-Path "$path\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
    $Rewrite = Test-Path "$path\rewrite_amd64_en-US.msi"

    
    if (($vnet) -or ($Rewrite)) {
        Install-Packages
    } elseif ((Test-Network)) {
        Invoke-Packages
    }else {
        Write-LogEvent "You are trying to run a script that requires an internet connection.`nPlease run New-OfflineServer to create a local zip on a PC with Internet access. " -Output
        Read-Host 'Please hit enter to continue...'
        return
    }
}