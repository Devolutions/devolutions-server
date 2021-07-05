function Update-SQLDatabase {
    param (
        [parameter(Mandatory, HelpMessage = "Web site / web app IIS path to your Devolutions Server (ex.: Default Web Site / dps)`nor physical path to your web app root folder (ex.: c:\inetpub\wwwroot\dps)" )][ValidateScript( 
            { if ( -Not ($_ | Test-Path) ) { throw 'File or folder does not exist' }return $true })][System.IO.FileInfo]$DVLSpath
    )
    Set-Location 'C:\Program Files (x86)\Devolutions\Devolutions Server Console\'
    .\DPS.Console.CLI.exe server db update --dps-path=$DVLSpath --verbose
}