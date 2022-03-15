function Install-DevoConsole {
    if (!(Test-Programs -DevoConsole -ErrorAction:SilentlyContinue)) {

        $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
        $path = "$Scriptpath\Packages"
        $Installer = 'Setup.DPS.Console.exe'
        try {
            Write-LogEvent 'Installing DVLS Console...'
            Start-Process -FilePath "$path\$Installer" -Args '/qn' -Verb RunAs -Wait
            Write-LogEvent 'Devolutions Console is now installed.'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
        try {
            Write-LogEvent "Removing $path\$Installer from $env:COMPUTERNAME"
            Remove-Item "$path\$Installer"
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    }
}