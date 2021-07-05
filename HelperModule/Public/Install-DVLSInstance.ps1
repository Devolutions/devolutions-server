function Install-DVLSInstance {
    Set-Location "${env:ProgramFiles(x86)}\Devolutions\Devolutions Server Console\"

    <#if (!(Get-WindowsFeature -Name Web-Server).Installed) {

        Import-Module $PSScriptRoot\PreReqsRebuild.psm1
        Start-DVLSSetup
    }#>

    #Response file to install the DVLS Instance 
    if (!(Test-Path $JSON)) {
        Invoke-JSON
    } else {
        .\DPS.Console.CLI.exe @$JSON --verbose
        try {
            Write-LogEvent "Removing $JSON from $env:COMPUTERNAME" 
            Remove-Item $JSON 
        } catch [System.Exception] { Write-EventLog $_ -Errors }
    }
}