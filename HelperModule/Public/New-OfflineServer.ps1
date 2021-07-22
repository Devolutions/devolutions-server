function New-OfflineServer {
    [CmdletBinding()]
    param(
        [parameter(Mandatory, HelpMessage = "Format for the Console Version being install. `nFormat: 2021.1.19.0")][ValidatePattern('[2][0][0-9][0-9][.][0-9][.][0-9][0-9][.][0]')][ValidateNotNullOrEmpty()][string]$ConsoleVersion,
        [parameter(HelpMessage = "If you do not have a license you can still run this script and add it after the installation.`nInclude full format from email.")][string]$serialKey
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
    $SQL = Get-RedirectedUrl -Url 'https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLEXPR_x64_ENU.exe'
    $SSMS = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/309b2c5d-1225-4123-a27c-ff4eb5f3a378'
    $destination = @(
        "$path\Setup.DPS.Console.$ConsoleVersion.exe"
        "$path\DVLS.Instance.$ConsoleVersion.zip"
        "$path\rewrite_amd64_en-US.msi"
        "$path\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
        "$path\SQL-SSEI-Expr.exe"
        "$path\SSMSinstaller.exe"
        "$path\Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll"
    )
    $source = @(
        "https://cdn.devolutions.net/download/Setup.DPS.Console.$ConsoleVersion.exe"
        "https://cdn.devolutions.net/download/RDMS/DVLS.$ConsoleVersion.zip"
        $IISurl
        $vnet
        $SQL
        $SSMS
        'https://onegetcdn.azureedge.net/providers/Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll'
    )

    try {
        Write-LogEvent 'Downloading Devolutions Server Console' -Output
        Write-LogEvent 'Downloading Devolutions Server Instance zip' -Output
        Write-LogEvent 'Downloading IIS URL Rewrite Module' -Output
        Write-LogEvent 'Downloading .Net 4.7.2' -Output
        Start-BitsTransfer $source -Destination $destination
        Write-LogEvent "Successfully downloaded $_" -Output 
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
    
    if (!(Test-Path $Scriptpath\Start-Me.ps1)) {
        $psI = @"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -noexit -File `".\Start-Me.ps1`"" -Verb RunAs }
import-module .\DVLS.HelperModule.psd1
Copy-Item ".\Packages\Microsoft.PackageManagement.NuGetProvider-2.8.5.208.dll" -Destination "C:\Program Files\PackageManagement\ProviderAssemblies" -Force
Install-DevolutionsServer -ConsoleVersion "$ConsoleVersion" -SQLServer -SQLIntegrated -SSMS -serialKey "$serialKey"
"@
        $psI | Out-File $Scriptpath\Start-Me.ps1
    }
    Compress-Archive -Path $Scriptpath -DestinationPath "$env:HOMEPATH\Desktop\OfflineServer.zip"
    Write-LogEvent "Zip was added to $env:HOMEPATH\Desktop\OfflineServer.zip" -Output
}