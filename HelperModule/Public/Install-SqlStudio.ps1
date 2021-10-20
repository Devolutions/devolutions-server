function Install-SqlStudio {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    New-EventSource
    if (Test-Programs -SSMS -ErrorAction:SilentlyContinue) {
        Write-LogEvent "Sql Server Management Studio is already present on the $env:COMPUTERNAME."
        return
    }
    if (Test-Network) {
        if (!(Test-SQL -SSMS)) { Invoke-SSMS } elseif (Test-SQL -SSMS) { Install-SSMS }
    } elseif (!(Test-Network)) {
        if (Test-SQL -SSMS) { Install-SSMS }else {
            Write-LogEvent "Installation files for Sql Server Management Studio are not present on $env:COMPUTERNAME `nin $path folder for offline installation.`n" -Output
        }
    }
}