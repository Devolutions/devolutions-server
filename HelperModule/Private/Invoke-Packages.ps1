function Invoke-Packages {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $dotNet = Test-Path "$path\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
    $Rewrite = Test-Path "$path\rewrite_amd64_en-US.msi"
    $vnet = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/bd59d20f-6bd9-40d4-b742-b892a3f2df15'
    $IISurl = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/58da94c9-2de7-4e33-809a-4610edcfad99'
    if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }
    else { Write-LogEvent "'$Path\Packages' folder already exists" }
    Install-IISFeatures
    If ((Test-dotNet) -and !($dotNet)) {
        Write-LogEvent 'Downloading .Net 4.7.2'
        try {
            Start-BitsTransfer -Source $vnet -Destination "$path\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
            Write-LogEvent 'Successfully downloaded .Net 4.7.2'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
        Install-Net472Core
    } elseif ((Test-dotNet) -and ($dotNet)) {
        Write-LogEvent '.net 4.7.2 EXE already present in folder'
        Install-Net472Core
    }
    if (Test-Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\URL Rewrite\') {
        Write-LogEvent 'Checking if IIS URL Rewrite is installed'
        $URregkey = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\URL Rewrite\'
        if ($URregkey.Version -ge 7.1) {
            Write-LogEvent 'IIS URL Rewrite module is already installed'
        }
    } elseif (!($Rewrite)) {
        Write-LogEvent 'Downloading IIS URL Rewrite Module'
        try {
            Start-BitsTransfer -Source $IISurl -Destination "$path\rewrite_amd64_en-US.msi"
            Write-LogEvent 'Successfully downloaded IIS URL Rewrite Module'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
        Install-IisUrlRewrite
    } else {
        Write-LogEvent 'Rewrite package EXE already present in folder'
        Install-IisUrlRewrite
    }
}