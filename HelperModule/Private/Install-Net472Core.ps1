function Install-Net472Core {
    # Installing .Net Framework 4.7.2
    $path = "$PSScriptRoot\Packages"
    $dotNet = Test-Path "$path\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
    $ExitCode = 0
    $net472 = "$PSScriptRoot\Packages\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
    Write-LogEvent 'Installing .Net Framework 4.7.2'
    $ExitCode = (Start-Process -FilePath 'msiexec.exe' -ArgumentList "/I $net472 /q" -Wait -PassThru).ExitCode
    if ($ExitCode -ne 0 -and $ExitCode -ne 1641 -and $ExitCode -ne 3010) {
        Write-LogEvent "Failed to install .Net Framework (Result=$ExitCode)."
    } else {
        Write-LogEvent 'Installation of .Net Framework finished!'
    }
    Try {
        Remove-Item $dotNet -Force
        Write-LogEvent "Removing $dotNet from $Env:COMPUTERNAME" -Output
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
}