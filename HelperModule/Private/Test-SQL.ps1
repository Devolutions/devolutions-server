function Test-SQL {
    param (
        [parameter()][switch]$SQLServer,
        [parameter()][switch]$SSMS
    )
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    if ($SQLServer) {
        Test-Path "$path\SQL-SSEI-Expr.exe"
    }
    if ($SSMS) {
        Test-Path "$path\SSMS-Setup-ENU.exe"
    }
}