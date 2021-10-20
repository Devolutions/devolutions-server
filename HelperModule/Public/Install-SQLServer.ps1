function Install-SqlServer {
    param(
        [parameter(HelpMessage = 'Used to set SQL Server to use Advanced settings')][switch]$AdvancedDB,
        [parameter(HelpMessage = 'Used to set SQL Server to use Integrated security')][switch]$SQLIntegrated,
        [parameter(HelpMessage = 'Used to enable TCP on your SQL Server Configuration')][switch]$TCPProtocol,
        [parameter(HelpMessage = 'Used to enable Named Pipes on your SQL Server Configuration')][switch]$NamedPipe
    )
    New-EventSource
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    if (Test-Programs -Sql -ErrorAction:SilentlyContinue) {
        Write-LogEvent "Sql Server is already present on the $env:COMPUTERNAME."
        return
    }
    if (Test-Network) {
        if (!(Test-SQL -SQLServer)) {
            if ($SQLIntegrated) { 
                if ($AdvancedDB) { Invoke-SqlServer -SQLIntegrated -AdvancedDB } else { Invoke-SqlServer -SQLIntegrated }
            } else {
                if ($AdvancedDB) { Invoke-SqlServer -AdvancedDB } else { Invoke-SqlServer }         
            }
        } elseif (Test-SQL -SQLServer) {
            if ($SQLIntegrated) { 
                if ($AdvancedDB) { Install-SQL -SQLIntegrated -AdvancedDB } else { Install-SQL -SQLIntegrated }
            } else {
                if ($AdvancedDB) { Install-SQL -AdvancedDB } else { Install-SQL }         
            }
        }
        try {
            $sqlServerName = 'SQLEXPRESS'
            $smo = 'Microsoft.SqlServer.Management.Smo.'
            $wmi = New-Object ($smo + 'Wmi.ManagedComputer').

            # Enable the TCP protocol on the default instance.
            if ($TCPProtocol) {
                Write-LogEvent 'Enabling TCP Protocol on Sql Server'
                $uri = "ManagedComputer[@Name='" + $env:COMPUTERNAME + "']/ServerInstance[@Name='" + $sqlServerName + "']/ServerProtocol[@Name='Tcp']"
                $Tcp = $wmi.GetSmoObject($uri)
                $Tcp.IsEnabled = $true
                $Tcp.Alter()
                $Tcp
            }
            # Enable the named pipes protocol for the default instance.
            if ($NamedPipe) {
                Write-LogEvent 'Enabling Named Pipes Protocol on Sql Server'
                $uri = "ManagedComputer[@Name='" + $env:COMPUTERNAME + "']/ServerInstance[@Name='" + $sqlServerName + "']/ServerProtocol[@Name='Np']"
                $Np = $wmi.GetSmoObject($uri)
                $Np.IsEnabled = $true
                $Np.Alter()
                $Np
            }
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    } elseif (!(Test-Network)) {
        if ((Test-SQL -SQLServer)) { Install-SQL } else {
            Write-LogEvent "Installation files for Sql Server are not present on $env:COMPUTERNAME `nin $path folder for offline installation.`n" -Output

        }
    }

}