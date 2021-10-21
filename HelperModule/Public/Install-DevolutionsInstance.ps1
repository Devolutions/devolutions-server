function Install-DevolutionsInstance {
    New-EventSource

    Set-Location "${env:ProgramFiles(x86)}\Devolutions\Devolutions Server Console\"
    #Response file to install the DVLS Instance
    $path = Split-Path -Path $PSScriptRoot -Parent
    $JSON = "$path\response.json"
    Install-IISPrerequisites
    if (!(Test-Path $JSON)) {
        Write-LogEvent 'Please use New-ResponseFile to generate the necessary file to run this command.' -Output
        Return
    } else {
        .\DPS.Console.CLI.exe @$JSON --verbose
    }
}