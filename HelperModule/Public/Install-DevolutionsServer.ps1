function Install-DevolutionsServer {
    #TODO Try and working in offline or simplify this
    param (
        [parameter(Mandatory, HelpMessage = "Format for the Console Version being install. `nFormat: 2021.1.17.0")][ValidatePattern('[2][0][0-9][0-9][.][0-9][.][0-9][0-9][.][0]')][ValidateNotNullOrEmpty()][string]$ConsoleVersion,
        [parameter(HelpMessage = 'Used to install an SQL Server')][switch]$SQLServer,
        [parameter(HelpMessage = 'Used to set SQL Server to use Integrated security')][switch]$SQLIntegrated,
        [parameter(HelpMessage = 'Used to install SQL Server Management Studio')][switch]$SSMS,
        [parameter(HelpMessage = 'Disables the use of HTTP(s) on your Devolutions Server.')][switch]$DisableHttps,
        [parameter(Mandatory, HelpMessage = 'Include full format from email.')][string]$serialKey = ''

    )
    try {
        New-EventSource
        if (Test-Network) {
            if (($SQLServer) -and !($SQLIntegrated) -and ($SSMS)) {
                Write-LogEvent 'Starting installation for SQL Server and SQL Server Management Studio'
                Install-SQLServer -SSMS
            } elseif (($SQLServer) -and ($SQLIntegrated) -and ($SSMS)) {
                Write-LogEvent 'Starting installation for SQL Server using integrated security and SQL Server Management Studio'
                Install-SQLServer -SSMS -SQLIntegrated
            } elseif (($SQLServer) -and !($SQLIntegrated) -and !($SSMS)) {
                Write-LogEvent 'Starting installation for SQL Server'
                Install-SQLServer
            } elseif (($SQLServer) -and !($SQLIntegrated) -and ($SSMS)) {

                Write-LogEvent 'Starting installation for SQL Server using integrated security'
                Install-SQLServer -SQLIntegrated
            }
            Write-LogEvent 'Starting installation of Devolutions Console'
            Install-DVLSConsole -ConsoleVersion $ConsoleVersion
            Write-LogEvent 'Getting JSON response file setup for installation.'
            if ($DisableHttps) { Invoke-JSON -serialKey $serialKey -DisableHttps }
            else { Invoke-JSON -serialKey $serialKey }
            Write-LogEvent 'Creating a Devolutions Server instance.'
            Install-DVLSInstance
            Write-LogEvent 'Installation process complete.' -Output
            if (!($DisableHttps)) {
                Write-LogEvent 'Please make sure you have configured IIS Bindings with certificate for HTTP(s).' -Output 
                Write-LogEvent 'Opening IIS...' -Output 
                Start-Process 'InetMgr.exe'
            }
        } else {
            Write-LogEvent "You are trying to run a script that requires an internet connection.`nPlease run New-OfflineServer to create a local zip on a PC with Internet access. " -Output
            Read-Host 'Please hit enter to continue...'
            return
        }
    } catch [System.Exception] { Write-LogEvent $_ -Errors }

}