function Get-DevoConsoleVersion {
    Set-Location "${env:ProgramFiles(x86)}\Devolutions Server Console\"
    .\DPS.Console.CLI.exe version
}