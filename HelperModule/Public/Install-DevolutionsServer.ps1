function Install-DevolutionsServer {
    #TODO Try to get working in offline or simplify this
    param (
        [parameter(Mandatory, HelpMessage = "Format for the Console Version being install. `nFormat: 2021.1.17.0")][ValidatePattern('[2][0][0-9][0-9][.][0-9][.][0-9][0-9][.][0]')][ValidateNotNullOrEmpty()][string]$ConsoleVersion,
        [parameter(HelpMessage = 'Used to install an SQL Server')][switch]$SQLServer,
        [parameter(HelpMessage = 'Used to set SQL Server to use Integrated security')][switch]$SQLIntegrated,
        [parameter(HelpMessage = 'Used to install SQL Server Management Studio')][switch]$SSMS,
        [parameter(HelpMessage = 'Disables the use of HTTP(s) on your Devolutions Server.')][switch]$DisableHttps,
        [parameter(Mandatory, HelpMessage = 'Include full format from email.')][string]$serialKey = ''
    )
    try {
        $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
        $path = "$Scriptpath\Packages"
        $network = Test-Network
        New-EventSource
        if ($network) {
            if (($SQLServer) -and !($SQLIntegrated) -and ($SSMS)) {
                Write-LogEvent 'Starting installation for SQL Server and SQL Server Management Studio'
                Install-SQLServer -SSMS -NamedPipe
            } elseif (($SQLServer) -and ($SQLIntegrated) -and ($SSMS)) {
                Write-LogEvent 'Starting installation for SQL Server using integrated security and SQL Server Management Studio'
                Install-SQLServer -SSMS -SQLIntegrated -NamedPipe
            } elseif (($SQLServer) -and !($SQLIntegrated) -and !($SSMS)) {
                Write-LogEvent 'Starting installation for SQL Server'
                Install-SQLServer -NamedPipe
            } elseif (($SQLServer) -and ($SQLIntegrated) -and !($SSMS)) {
                Write-LogEvent 'Starting installation for SQL Server using integrated security'
                Install-SQLServer -SQLIntegrated -NamedPipe
            }
            Write-LogEvent 'Starting installation of Devolutions Console'
            Install-DVLSConsole -ConsoleVersion $ConsoleVersion
            Install-PrerequisiteSetup
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
        } elseif (!($network)) {
            
            if (($SQLServer) -and (Test-Path -Path "$path\SQL-SSEI-Expr.exe")) {
                if (($SQLServer) -and ($SQLIntegrated)) {
                    Write-LogEvent 'Starting installation for SQL Server and SQL Server Management Studio'
                    Install-SQLServer -SQLIntegrated -TCPProtocol -NamedPipe
                } elseif (($SQLServer) -and !($SQLIntegrated)) {
                    Write-LogEvent 'Starting installation for SQL Server'
                    Install-SQLServer -TCPProtocol -NamedPipe
                } 
            } elseif (($SQLServer) -and !(Test-Path -Path "$path\SQL-SSEI-Expr.exe")) {
                Write-LogEvent 'No EXE was found to install SQL Server' -Output
                Write-LogEvent "Please add exe to $path folder and rerun command" -Output
                continue  
            }
            
            if (($SSMS) -and (Test-Path -Path "$path\SSMSinstaller.exe")) {
                Install-SSMS
            } elseif (($SSMS) -and !(Test-Path -Path "$path\SSMSinstaller.exe")) {
                Write-LogEvent 'No EXE was found to install SQL Server Management Studio' -Output
                Write-LogEvent "Please add exe to $path folder and rerun command" -Output
                continue  
            }

            if (Test-Path -Path "$path\Setup.DPS.Console.$ConsoleVersion.exe") {
                Write-LogEvent 'Starting installation of Devolutions Console'
                Install-DVLSConsole -ConsoleVersion $ConsoleVersion
                Install-PrerequisiteSetup
                Write-LogEvent 'Getting JSON response file setup for installation.'
                if ($DisableHttps) { Invoke-JSON -serialKey $serialKey -DisableHttps }
                else { Invoke-JSON -serialKey $serialKey }
                if (Test-Path -Path "$path\DVLS.Instance.$ConsoleVersion.zip") {
                    Write-LogEvent 'Creating a Devolutions Server instance.'
                    Install-DVLSInstance
                    Write-LogEvent 'Installation process complete.' -Output
                    if (!($DisableHttps)) {
                        Write-LogEvent 'Please make sure you have configured IIS Bindings with certificate for HTTP(s).' -Output 
                        Write-LogEvent 'Opening IIS...' -Output 
                        Start-Process 'InetMgr.exe'
                    }
                } else {
                    Write-LogEvent 'No zip was found to install your Devolutions Server Instance' -Output
                    Write-LogEvent "Please add zip to $path folder and rerun command" -Output
                    continue
                }
            } else {
                Write-LogEvent 'No EXE was found to install your Devolutions Server Console' -Output
                Write-LogEvent "Please add exe to $path folder and rerun command" -Output
                return 
            }
        } else {
            Write-LogEvent 'You are trying to run a script that requires an internet connection and/or local files if not online.' -Output
            Write-LogEvent 'Please run New-OfflineServer to create a local zip on a PC with Internet access.' -Output
            Write-LogEvent "Place files on the your Offline Server here: $path" -Output
            Read-Host 'Please hit enter to continue...'
            return
        }
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
}