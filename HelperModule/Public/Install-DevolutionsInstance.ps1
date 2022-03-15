function Install-DevolutionsInstance {
    param (
        [Parameter(HelpMessage = 'Location of Devolution Server Response file (.json file)')][string]$ResponseFile 
    ) 
    New-EventSource
    if (Test-dotNet) {
        Write-LogEvent '.NET Framework 4.8 is not installed, please use Install-IISPrerequisites then rerun this script' -Output
        return
    }

    Set-Location "${env:ProgramFiles(x86)}\Devolutions\Devolutions Server Console\"
    #Response file to install the DVLS Instance
    $path = Split-Path -Path $PSScriptRoot -Parent
    if ($null -eq $ResponseFile) {$ResponseFile = "$path\response.json"} 
    if (!(Test-Path $ResponseFile)) {
        Write-LogEvent 'Please use New-ResponseFile to generate the necessary file to run this command.' -Output
        Return
    } else {
        Install-IISPrerequisites
        .\DPS.Console.CLI.exe @$ResponseFile --verbose
    }
}