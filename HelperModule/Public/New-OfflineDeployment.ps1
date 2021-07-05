function New-OfflineDeployment {
    $path = "$PSScriptRoot\Packages"
    if (!(Test-Path $path)) { New-Item $path -ItemType Directory -Force }
    Write-LogEvent "Checking if $PSScriptRoot\Packages exists" -Output
    $path = "$PSScriptRoot\Packages"
    $Dotnet = Test-Path "$path\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
    $vnet = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/2eae5a8c-fc8b-437e-a381-9dc999eef48e'
    $IISurl = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/58da94c9-2de7-4e33-809a-4610edcfad99'
    $Rewrite = Test-Path "$path\rewrite_amd64_en-US.msi"
    if (!($Dotnet) -or !($Rewrite)) {
        try {
            Write-LogEvent 'Downloading .Net 4.7.2' -Output
            Start-BitsTransfer -Source $vnet -Destination "$path\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
            Write-LogEvent 'Successfully downloaded .Net 4.7.2' -Output
            Write-LogEvent 'Downloading IIS URL Rewrite Module' -Output
            Start-BitsTransfer -Source $IISurl -Destination "$path\rewrite_amd64_en-US.msi"
            Write-LogEvent 'Successfully downloaded IIS URL Rewrite Module' -Output
        } catch { Write-LogEvent "Download encountered an error: $PSItem" -Output }
    }
    if (!(Test-Path $PSScriptRoot\Install-Script.ps1)) {
        $psI = @'
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs }
import-module "$PSScriptRoot\DVLS.HelperModule.psd1"
Start-PrerequisiteSetup
'@
        $psI | Out-File $PSScriptRoot\Install-Script.ps1
    }
    Compress-Archive -Path $PSScriptRoot\ -DestinationPath $PSScriptRoot
}
