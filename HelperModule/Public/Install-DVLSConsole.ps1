function Install-DVLSConsole {
    param(
        [parameter(Mandatory, HelpMessage = "Format for the Console Version being install. `nFormat: 2021.1.17.0")][ValidateLength(11)][ValidatePattern('[2][0][0-9][0-9][.][0-9][.][0-9][0-9][.][0]')][ValidateNotNullOrEmpty()][string]$ConsoleVersion,
        [parameter(HelpMessage = "If you do not have a license you can still run this script and add it after the installation.`nInclude full format from email.")][string]$serialKey
    )
    if (!(Test-Programs -DevoConsole -ErrorAction:SilentlyContinue)) {
        
        $Path = "$PSScriptRoot\Programs"
        $DevoPath = "${env:ProgramFiles(x86)}\Devolutions\Devolutions Server Console\DPS.Console.UI.exe"
        #Install-DVLSConsole {
        Write-LogEvent 'Downloading DVLS Console...'
        $Installer = "Setup.DPS.Console.$ConsoleVersion.exe"
        $URL = "https://cdn.devolutions.net/download/$Installer"
        try { Start-BitsTransfer $URL -Destination "$Path\$Installer" } catch [System.Exception] { Write-EventLog $_ -Errors }
        Write-LogEvent 'Installing DVLS Console...'
        try {
            Start-Process -FilePath "$Path\$Installer" -Args '/qn' -Verb RunAs -Wait 
            Write-LogEvent 'Devolutions Console is now installed.'
        } catch [System.Exception] { Write-EventLog $_ -Errors }
        try {
            Write-LogEvent "Removing $Path\$Installer from $env:COMPUTERNAME"
            Remove-Item "$Path\$Installer" 
        } catch [System.Exception] { Write-EventLog $_ -Errors }

        #Shortcut for DVLS
        try {
            Write-LogEvent 'Creating shortcut for Devolutions Console.'
            $WshShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WshShell.CreateShortcut("$Home\Desktop\DVLS Console.lnk")
            $Shortcut.TargetPath = $DevoPath
            $Shortcut.Save()
            Write-LogEvent 'Shortcut for Devolutions Console has been created.'
        } catch [System.Exception] { Write-EventLog $_ -Errors }
    } else {
        Write-LogEvent 'Devolutions Console is already installed.'
    }
}