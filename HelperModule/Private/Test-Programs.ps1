function Test-Programs {
    param(
        [parameter()][switch]$Sql,
        [parameter()][switch]$SSMS,
        [parameter()][switch]$DevoConsole
    )
    if ($Sql) {
        $directoryInfo = Get-ChildItem 'C:\SQL2019' -Force | Measure-Object
        if ($directoryInfo.count -gt '1') {
            return $true
        } else {
            return $false
        }
    }
    if ($SSMS) {
        if (Test-Path -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe") { return $true }
        else {
            return $false
        }
    }

    if ($DevoConsole) {
        if (Test-Path -Path "${env:ProgramFiles(x86)}\Devolutions\Devolutions Server Console\DPS.Console.UI.exe") { return $true }
        else {
            return $false
        }
    }
}