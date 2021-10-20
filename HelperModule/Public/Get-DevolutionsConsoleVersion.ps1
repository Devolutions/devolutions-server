function Get-DevolutionsConsoleVersion {
    Set-Location "${env:ProgramFiles(x86)}\Devolutions\Devolutions Server Console\"
    .\DPS.Console.CLI.exe version
}