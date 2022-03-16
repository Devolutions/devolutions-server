function Install-SqlServer {
    [CmdletBinding(DefaultParameterSetName = 'SQLAccounts')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'SQLAccounts', Position = 0)]
        [System.Management.Automation.PSCredential]$SQLOwnerAccount,
    
        [Parameter(ParameterSetName = 'SQLAccounts', Position = 1)]
        [System.Management.Automation.PSCredential]$SQLSchedulerAccount,
    
        [Parameter(ParameterSetName = 'SQLAccounts', Position = 2)]
        [System.Management.Automation.PSCredential]$SQLAppPoolAccount,
        [parameter(Mandatory, ParameterSetName = 'Integrated', HelpMessage = 'Used to set SQL Server to use Integrated security', Position = 0)]
        [switch]$SQLIntegrated,
        [parameter(HelpMessage = 'Used for Advanced settings for SQL Server installation')][switch]$AdvancedDB,
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
                if ($AdvancedDB) { Invoke-SqlServer -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount -AdvancedDB 
                } else { Invoke-SqlServer -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount }         
            }
        } elseif (Test-SQL -SQLServer) {
            if ($SQLIntegrated) { 
                if ($AdvancedDB) { Install-SQL -SQLIntegrated -AdvancedDB } else { Install-SQL -SQLIntegrated }
            } else {
                if ($AdvancedDB) { Install-SQL -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount -AdvancedDB 
                } else { Install-SQL -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount }         
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
        if ((Test-SQL -SQLServer)) { Install-SQL -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount 
        } else { Write-LogEvent "Installation files for Sql Server are not present on $env:COMPUTERNAME `nin $path folder for offline installation.`n" -Output
        }
    }
}