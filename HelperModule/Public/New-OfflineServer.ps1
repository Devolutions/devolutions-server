function New-OfflineServer {
    [CmdletBinding(DefaultParameterSetName = 'GA')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'GA', Position = 0)][switch]$GA,
        [Parameter(Mandatory, ParameterSetName = 'LTS', Position = 0)][switch]$LTS
    )
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    Write-LogEvent "Checking if $path\Packages exists" -Output
    if (!(Test-Path $path)) {
        New-Item $path -ItemType Directory -Force
        Write-LogEvent "Created folder $path\Packages" -Output
    }
    $vnet = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/bd59d20f-6bd9-40d4-b742-b892a3f2df15'
    $IISurl = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/58da94c9-2de7-4e33-809a-4610edcfad99'
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
        "$path\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
    )
    $source = @(
        $DevoConsole
        $DevoZIP
        $IISurl
        $vnet
    )

    try {
        Write-LogEvent 'Downloading Devolutions Server Console' -Output
        Write-LogEvent 'Downloading Devolutions Server Instance zip' -Output
        Write-LogEvent 'Downloading IIS URL Rewrite Module' -Output
        Write-LogEvent 'Downloading .Net 4.7.2' -Output
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