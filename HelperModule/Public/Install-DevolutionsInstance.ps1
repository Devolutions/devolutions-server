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
        try {
            Write-LogEvent "Removing $JSON from $env:COMPUTERNAME"
            Remove-Item $JSON
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    }
    <# Used for removing the ZIP. Took off for now as I believe we should keep the zip in case.
    try {
        Write-LogEvent "Removing $path\Packages\DVLS.Instance.zip from $env:COMPUTERNAME"
        Remove-Item "$path\Packages\DVLS.Instance.zip"
    } catch [System.Exception] { Write-LogEvent $_ -Errors } #>
}