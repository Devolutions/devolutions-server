function Install-IisUrlRewrite {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $url1 = "$path\rewrite_amd64_en-US.msi"
    $ExitCode = 0
    $Rewrite = Test-Path $url1
    $IISurl = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/58da94c9-2de7-4e33-809a-4610edcfad99'

    if (Test-Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\URL Rewrite\') {
        Write-LogEvent 'Checking if IIS URL Rewrite is installed'
        $URregkey = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\URL Rewrite\'
        if ($URregkey.Version -ge 7.1) {
            Write-LogEvent 'IIS URL Rewrite module is already installed'
            return
        }
    } elseif (!($Rewrite)) {
        Write-LogEvent 'Downloading IIS URL Rewrite Module'
        try {
            Start-BitsTransfer -Source $IISurl -Destination "$path\rewrite_amd64_en-US.msi"
            Write-LogEvent 'Successfully downloaded IIS URL Rewrite Module'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    } else {
        Write-LogEvent 'Rewrite package EXE already present in folder'
    }
    
    Write-LogEvent 'Installing IIS URL Rewrite Module'
    $Exitcode = (Start-Process -FilePath 'msiexec.exe' -ArgumentList "/I $url1 /q" -Wait -PassThru).ExitCode

    if ($ExitCode -ne 0 -and $ExitCode -ne 1641 -and $ExitCode -ne 3010) {
        Write-LogEvent "Failed to install IIS URL Rewrite 2.0 Module (Result=$ExitCode)."
    } else {
        Write-LogEvent 'Installation of IIS URL Rewrite 2.0 Module finished!'
    }
    Try {
        Remove-Item $url1 -Force
        Write-LogEvent "Removing $url1 from $Env:COMPUTERNAME" -Output
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
}