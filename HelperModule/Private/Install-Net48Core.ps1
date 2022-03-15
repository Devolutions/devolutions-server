function Install-Net48Core {
    # Installing .Net Framework 4.8
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    $net48 = "$path\NDP48-x86-x64-AllOS-ENU.exe"
    $ExitCode = 0
    $dotNet = Test-Path $net48
    $vnet = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/e37e3ab5-37ba-4f9d-af4d-b3ed6fcb1178'

    if (Test-dotNet) {
        if (!($dotNet)) {
            Write-LogEvent 'Downloading .Net 4.8'
            try {
                Start-BitsTransfer -Source $vnet -Destination "$path\NDP48-x86-x64-AllOS-ENU.exe"
                Write-LogEvent 'Successfully downloaded .Net 4.8'
            } catch [System.Exception] { Write-LogEvent $_ -Errors }
        } elseif ($dotNet) {
            Write-LogEvent '.net 4.8 EXE already present in folder'
        } 
    
        Write-LogEvent 'Installing .Net Framework 4.8'
        $ExitCode = (Start-Process $net48 -ArgumentList 'Setup /q /norestart' -Wait -PassThru).ExitCode
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
    }else {
        Write-LogEvent '.Net Framework is already installed'
    }
}

