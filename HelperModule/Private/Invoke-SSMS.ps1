function Invoke-SSMS {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }
    $SqlStudio = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/309b2c5d-1225-4123-a27c-ff4eb5f3a378'

    $destination = "$path\SSMS-Setup-ENU.exe"
    $source = $SqlStudio

    try {
        Write-LogEvent 'Downloading SQL Server Management Studio...'
        Start-BitsTransfer $source -Destination $destination
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
    Install-SSMS
}