function Install-IisUrlRewrite {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $url1 = "$path\rewrite_amd64_en-US.msi"
    $ExitCode = 0

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