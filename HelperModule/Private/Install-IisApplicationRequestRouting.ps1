function Install-IisApplicationRequestRouting {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $url1 = "$path\requestRouter_amd64.msi"
    $ExitCode = 0
    $requestRouter = Test-Path $url1
    $AppRequestRouting = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/f19f07f3-5ea4-436d-a3ba-4bb69d373321'

    if (Test-Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\Application Request Routing\') {
        Write-LogEvent 'Checking if IIS Application Request Routing (AAR) is installed'
        $Appregkey = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\Application Request Routing\'
        if ($Appregkey.Version -ge 3.0) {
            Write-LogEvent 'IIS Application Request Routing (AAR) is already installed'
            return
        }
    } elseif (!($requestRouter)) {
        Write-LogEvent 'Downloading IIS Application Request Routing (AAR)'
        try {
            Start-BitsTransfer -Source $AppRequestRouting -Destination "$path\requestRouter_amd64.msi"
            Write-LogEvent 'Successfully downloaded IIS Application Request Routing (AAR)'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    } else {
        Write-LogEvent 'Application Request Routing (AAR) package EXE already present in folder'
    }

    Write-LogEvent 'Installing Application Request Routing (AAR)'
    $Exitcode = (Start-Process -FilePath 'msiexec.exe' -ArgumentList "/I $url1 /q" -Wait -PassThru).ExitCode
    
    # Enable ARR proxy
    & "$Env:WinDir\system32\inetsrv\appcmd.exe" 'set' 'config' '-section:system.webServer/proxy' '-enabled:true' '/commit:apphost'

    if ($ExitCode -ne 0 -and $ExitCode -ne 1641 -and $ExitCode -ne 3010) {
        Write-LogEvent "Failed to install IIS Application Request Routing (AAR) (Result=$ExitCode)."
    } else {
        Write-LogEvent 'Installation of IIS Application Request Routing (AAR) finished!'
    }
    Try {
        Remove-Item $url1 -Recurse -Force
        Write-LogEvent "Removing $url1 from $Env:COMPUTERNAME" -Output
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
}

