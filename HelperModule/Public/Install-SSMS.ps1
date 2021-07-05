function Install-SSMS {
    if (!(Test-Programs -SSMS -ErrorAction:SilentlyContinue)) {
        $SQLStudio = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/309b2c5d-1225-4123-a27c-ff4eb5f3a378'
        $path = "$PSScriptRoot\Programs"
        if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }
        $Installer = 'SSMSinstaller.exe'
        Write-LogEvent 'Downloading SQL Server Management Studio...'
        try { Start-BitsTransfer $SQLStudio -Destination "$path\$Installer" } catch [System.Exception] { Write-LogEvent $_ -Errors }
        Write-LogEvent 'Installing SQL Server Management Studio...'
        Set-Location $path
        try {
            Start-Process -FilePath "$path\$Installer" -Args '/install /quiet /norestart' -Verb RunAs -Wait
            Write-LogEvent 'SQL Server Management Studio installed' 
        } catch [System.Exception] { Write-LogEvent $_ -Errors }        
        try {
            Write-LogEvent "Removing $path\$Installer from $Env:ComputerName"
            Remove-Item "$path\$Installer" 
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    } else {
        Write-LogEvent 'SQL Server Management Studio is already installed.'
    }
}