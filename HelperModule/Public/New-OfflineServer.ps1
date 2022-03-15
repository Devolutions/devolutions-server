function New-OfflineServer {
    [CmdletBinding(DefaultParameterSetName = 'GA')]
    param (
        [Parameter(ParameterSetName = 'GA', Position = 0)][switch]$GA,
        [Parameter(ParameterSetName = 'LTS', Position = 0)][switch]$LTS
    )
    #TODO Need to add license key and Integrated security
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    Write-LogEvent "Checking if $path\Packages exists" -Output
    if (!(Test-Path $path)) {
        New-Item $path -ItemType Directory -Force
        Write-LogEvent "Created folder $path\Packages" -Output
    }
    $vnet = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/e37e3ab5-37ba-4f9d-af4d-b3ed6fcb1178'	
    $IISurl = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/58da94c9-2de7-4e33-809a-4610edcfad99'
    $AppRequestRouting = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/f19f07f3-5ea4-436d-a3ba-4bb69d373321'
    if ($GA) {
        $PatternEXE = 'DPSConsole.Exe'
        $PatternZip = 'DPS.Url'
    }
    if ($LTS) {
        $PatternEXE = 'DPSConsoleLts.Exe'
        $PatternZip = 'DPSLts.Url'
    }
    $DevoConsole = (Get-DevolutionsLinks -Pattern $PatternEXE).Trim()
    $DevoZIP = (Get-DevolutionsLinks -Pattern $PatternZip).Trim()

    $destination = @(
        "$path\Setup.DPS.Console.exe"
        "$path\DVLS.Instance.zip"
        "$path\rewrite_amd64_en-US.msi"
        "$path\NDP48-x86-x64-AllOS-ENU.exe"
        "$path\requestRouter_amd64.msi"
    )
    $source = @(
        $DevoConsole
        $DevoZIP
        $IISurl
        $vnet
        $AppRequestRouting
    )

    try {
        Write-LogEvent 'Downloading Devolutions Server Console' -Output
        Write-LogEvent 'Downloading Devolutions Server Instance zip' -Output
        Write-LogEvent 'Downloading IIS URL Rewrite Module' -Output
        Write-LogEvent 'Downloading .Net' -Output
        Write-LogEvent 'Downloading Application Request Routing (ARR)' -Output
        Start-BitsTransfer $source -Destination $destination
    } catch [System.Exception] { Write-LogEvent $_ -Errors }


    if (!(Test-Path $Scriptpath\Start-Me.ps1)) {
        if ($LTS) {
            $psI = @'
#Requires -RunAsAdministrator
cd $PSscriptRoot
Import-Module ".\Devolutions.Server.HelperModule.psd1"
Install-DevolutionsServer -LTS
'@
            $psI | Out-File $Scriptpath\Start-Me.ps1
        } else {
            $psI = @'
#Requires -RunAsAdministrator
cd $PSscriptRoot
Import-Module ".\Devolutions.Server.HelperModule.psd1"
Install-DevolutionsServer -GA
'@
            $psI | Out-File $Scriptpath\Start-Me.ps1
        }
    }
    Compress-Archive -Path $Scriptpath -DestinationPath "$env:HOMEPATH\Desktop\OfflineServer.zip"
    Write-LogEvent "Zip was added to $env:HOMEPATH\Desktop\OfflineServer.zip" -Output
    Remove-Item "$Scriptpath\Packages" -Recurse -Force
    Remove-Item "$Scriptpath\Start-Me.ps1" -Force
    Write-LogEvent "Removed $Scriptpath\Start-Me.ps1 and $Scriptpath\Packages" -Output
}