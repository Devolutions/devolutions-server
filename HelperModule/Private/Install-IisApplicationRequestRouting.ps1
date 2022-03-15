function Install-IisApplicationRequestRouting {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $url1 = "$path\requestRouter_amd64.msi"
    $ExitCode = 0

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