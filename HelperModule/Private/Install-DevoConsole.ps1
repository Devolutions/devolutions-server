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
        <#Shortcut for DVLS
        $DevoPath = "${env:ProgramFiles(x86)}\Devolutions\Devolutions Server Console\DPS.Console.UI.exe"
        try {
            Write-LogEvent 'Creating shortcut for Devolutions Console.'
            $WshShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WshShell.CreateShortcut("$Home\Desktop\DVLS Console.lnk")
            $Shortcut.TargetPath = $DevoPath
            $Shortcut.Save()
            Write-LogEvent 'Shortcut for Devolutions Console has been created.'
        } catch [System.Exception] { Write-LogEvent $_ -Errors } #>
    }
}