function Test-Packages {
    Write-LogEvent "Checking if $PSScriptRoot\Packages exists"
    $path = "$PSScriptRoot\Packages"
    $vnet = Test-Path "$path\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
    $Rewrite = Test-Path "$path\rewrite_amd64_en-US.msi"

    if (($vnet) -and ($Rewrite) -and !(Test-Network)) {
        Install-Packages
    } elseif (($vnet) -and ($Rewrite) -and (Test-Network)) {
        Install-Packages
    } elseif (!($vnet) -or !($Rewrite) -and (Test-Network)) {
        Invoke-Packages
    } else {
        Write-LogEvent 'An internet access is required to download URL Rewrite Module and .Net Framework.'
        Write-LogEvent 'You can on run New-OfflineDeployment on your local PC and tranfer the ZIP over.' -Output
        Write-LogEvent 'Or you can manually download files here are the download pages for these two prerequisites :' -Output
        Write-LogEvent "Please place both files in the a folder named $Path" -Output
        Write-LogEvent 'URL Rewrite Module : ' -Output
        Write-LogEvent 'https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi' -Output
        Write-LogEvent '.Net Framework 4.7.2 for Server Core : ' -Output
        Write-LogEvent 'https://go.microsoft.com/fwlink/?LinkId=863265' -Output
        Read-Host 'Hit enter to continue...'
    }
}