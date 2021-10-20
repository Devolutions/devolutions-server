function Install-DevolutionsConsole {
    [CmdletBinding(DefaultParameterSetName = 'GA')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'GA', Position = 0)][switch]$GA,
        [Parameter(Mandatory, ParameterSetName = 'LTS', Position = 0)][switch]$LTS
    )
    New-EventSource
    if (Test-Programs -DevoConsole) {
        Write-LogEvent "Devolutions Server Console is already present on the $env:COMPUTERNAME."
        return
    }
    if (Test-Network) {
        if (!(Test-DevoConsole)) {      
            if ($GA) { Invoke-DevolutionsConsole -GA }
            if ($LTS) { Invoke-DevolutionsConsole -LTS }
        } elseif (Test-DevoConsole) { Install-DevoConsole }  
    } elseif (!(Test-Network)) {
        if (Test-DevoConsole) { Install-DevoConsole } else {
            Write-LogEvent "Installation files for Devolutions Server Console are not present on $env:COMPUTERNAME `nfor offline installation.`n" -Output
        }
    }
}
