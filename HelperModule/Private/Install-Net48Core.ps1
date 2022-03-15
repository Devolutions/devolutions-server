function Install-Net48Core {
    # Installing .Net Framework 4.8
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $ExitCode = 0
    $net48 = "$path\NDP48-x86-x64-AllOS-ENU.exe"
    Write-LogEvent 'Installing .Net Framework 4.8'
    $ExitCode = (Start-Process $net48 -ArgumentList "Setup /q /norestart" -Wait -PassThru).ExitCode
    if ($ExitCode -ne 0 -and $ExitCode -ne 1641 -and $ExitCode -ne 3010) {
        Write-LogEvent "Failed to install .Net Framework (Result=$ExitCode)."
    } else {
        Write-LogEvent 'Installation of .Net Framework finished!'
        Write-LogEvent 'Your computer will restart in 1 minute to complete installation'
        shutdown /r
    }
    Try {
        Remove-Item $net48 -Force
        Write-LogEvent "Removing $net48 from $Env:COMPUTERNAME" -Output
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
}