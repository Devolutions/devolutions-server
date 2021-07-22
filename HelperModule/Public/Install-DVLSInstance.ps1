function Install-DVLSInstance {
    Set-Location "${env:ProgramFiles(x86)}\Devolutions\Devolutions Server Console\"

    #TODO Add Zip file option
    #Response file to install the DVLS Instance 
    $path = Split-Path -Path $PSScriptRoot -Parent
    $JSON = "$path\response.json"
    if (!(Test-Path $JSON)) {
        Invoke-JSON
    } else {
        .\DPS.Console.CLI.exe @$JSON --verbose
        try {
            Write-LogEvent "Removing $JSON from $env:COMPUTERNAME" 
            Remove-Item $JSON 
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    }
}