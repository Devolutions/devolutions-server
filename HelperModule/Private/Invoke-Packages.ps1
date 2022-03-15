function Invoke-Packages {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $dotNet = Test-Path "$path\NDP48-x86-x64-AllOS-ENU.exe"
    $Rewrite = Test-Path "$path\rewrite_amd64_en-US.msi"
    $requestRouter = Test-Path "$path\requestRouter_amd64.msi"
    $vnet = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/2b939921-b82e-400a-8b2a-4db87fc65da9'
    $IISurl = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/58da94c9-2de7-4e33-809a-4610edcfad99'
    $AppRequestRouting = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/f19f07f3-5ea4-436d-a3ba-4bb69d373321'
    if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }
    else { Write-LogEvent "'$Path\Packages' folder already exists" }
    Install-IISFeatures

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

    if (Test-Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\Application Request Routing\') {
        Write-LogEvent 'Checking if IIS Application Request Routing (AAR) is installed'
        $Appregkey = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\Application Request Routing\'
        if ($Appregkey.Version -ge 3.0) {
            Write-LogEvent 'IIS Application Request Routing (AAR) is already installed'
        }
    } elseif (!($requestRouter)) {
        Write-LogEvent 'Downloading IIS Application Request Routing (AAR)'
        try {
            Start-BitsTransfer -Source $AppRequestRouting -Destination "$path\requestRouter_amd64.msi"
            Write-LogEvent 'Successfully downloaded IIS Application Request Routing (AAR)'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
        Install-IisApplicationRequestRouting 
    } else {
        Write-LogEvent 'Application Request Routing (AAR) package EXE already present in folder'
        Install-IisApplicationRequestRouting
    }
    If ((Test-dotNet) -and !($dotNet)) {
        Write-LogEvent 'Downloading .Net 4.8'
        try {
            Start-BitsTransfer -Source $vnet -Destination "$path\NDP48-x86-x64-AllOS-ENU.exe"
            Write-LogEvent 'Successfully downloaded .Net 4.8'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
        Install-Net48Core
    } elseif ((Test-dotNet) -and ($dotNet)) {
        Write-LogEvent '.net 4.8 EXE already present in folder'
        Install-Net48Core
    } 
}