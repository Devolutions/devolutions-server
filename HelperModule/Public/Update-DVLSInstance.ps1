function Update-DVLSInstance {
    param (
        [parameter(Mandatory, HelpMessage = "Web site / web app IIS path to your Devolutions Server (ex.: Default Web Site / dps)`nor physical path to your web app root folder (ex.: c:\inetpub\wwwroot\dps)" )][ValidateScript(
            { if ( -Not ($_ | Test-Path) ) { throw 'File or folder does not exist' }return $true })][System.IO.FileInfo]$DVLSpath,
        [parameter(Mandatory = $false, HelpMessage = 'Please enter Console Password')][SecureString]$ConsolePassword = '',
        [parameter(Mandatory = $false, HelpMessage = 'If you are planning on installing via Zip, please enter path.')][ValidateScript(
            { if ( -Not ($_ | Test-Path) ) { throw 'File or folder does not exist' }if (-Not ($_ | Test-Path -PathType Leaf) ) {
                    throw 'The Path argument must be a file. Folder paths are not allowed.'
                }
                if ($_ -notmatch '(\.zip)') {
                    throw 'The file specified in the path argument must a Zip.'
                } return $true })][System.IO.FileInfo]$ZIPPath
    )
    $DevoPath = "${env:ProgramFiles(x86)}\Devolutions\Devolutions Server Console\"
    if ($UpdateDVLS) {
        if ($null -eq $ConsolePassword -and $null -eq $ZIPPath) {
            Set-Location $DevoPath
            .\DPS.Console.CLI.exe server upgrade --dps-path=$DVLSpath --accept-eula --quiet --verbose
        } elseif ($null -eq $ConsolePassword -and $null -ne $ZIPPath) {
            Set-Location $DevoPath
            .\DPS.Console.CLI.exe server upgrade --dps-path=$DVLSpath --upgrade-zip=$ZIPPath --accept-eula --quiet --verbose
        }
    } elseif ($null -ne $ConsolePassword -and $null -eq $ZIPPath) {
        Set-Location $DevoPath
        .\DPS.Console.CLI.exe server upgrade --dps-path=$DVLSpath --console-pwd=$ConsolePassword --accept-eula --quiet --verbose
    } else {
        Set-Location $DevoPath
        .\DPS.Console.CLI.exe server upgrade --dps-path=$DVLSpath --console-pwd=$ConsolePassword --upgrade-zip=$ZIPPath --accept-eula --quiet --verbose
    }
}