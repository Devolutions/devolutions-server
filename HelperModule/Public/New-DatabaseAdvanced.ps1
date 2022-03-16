function New-DatabaseAdvanced {
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
        [parameter(Mandatory, HelpMessage = 'Used to set SQL Database Name')][string]$DatabaseName,
        [parameter(Mandatory, HelpMessage = 'SQL Database Recovery model setting.')]
        [ValidateSet('BulkLogged', 'Full', 'Simple')][string]$RecoveryModel

    )
    #TODO redo this section
    New-EventSource
    #modules required for the DB creation and setting the login rights
    Install-PSModules
    if (!(Get-Module SqlServer)) {
        if (!($SQLIntegrated)) {
            $SQLOwner = $SQLOwnerAccount.GetNetworkCredential().UserName
            $SQLScheduler = $SQLSchedulerAccount.GetNetworkCredential().UserName
            $SQLAppPool = $SQLAppPoolAccount.GetNetworkCredential().UserName
        }
        try {
            $comp = $env:ComputerName
            $sql = [Microsoft.SqlServer.Management.Smo.Server]::new("$comp\SQLEXPRESS")
            #set mixed mode for authentication
            if ($SQLIntegrated) {
                $sql.Settings.LoginMode = 'Integrated'
            } else { $sql.Settings.LoginMode = 'Mixed' }
            $sql.Alter()
            try { Get-Service -Name 'MSSQL$SQLEXPRESS' | Restart-Service } catch [System.Exception] { Write-LogEvent $_ -Errors }

            # set instance and database name variables
            $dbname = $DatabaseName
            $SqlInstance = 'localhost\SQLEXPRESS'

            # change to SQL Server instance directory
            Set-Location SQLSERVER:\SQL\$SqlInstance

            # create object and database
            $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $SqlInstance, $dbname
            $db.Create()
            Write-LogEvent "New database SQL Server located: $SqlInstance and Database Name: $dbname." -Output

            # set recovery model
            $db.RecoveryModel = $RecoveryModel
            $db.Alter()
            Write-LogEvent "Recovery model is set to $RecoveryModel" -Output

            # change owner
            if ($SQLIntegrated) {
                $db.SetOwner("$env:USERDOMAIN\$env:USERNAME")
                $db.Alter()
                Write-LogEvent "DB owner set to $env:USERDOMAIN\$env:USERNAME" -Output
            } else {
                $db.SetOwner('sa')
                $db.Alter()
                Write-LogEvent 'DB owner set to sa account.' -Output
            }

            # change data file size and autogrowth amount
            foreach ($datafile in $db.filegroups.files) {
                $datafile.size = 1048576
                $datafile.growth = 262144
                $datafile.growthtype = 'kb'
                $datafile.Alter()
                Write-LogEvent 'DB autogrowth configured to default settings' -Output
            }

            # change log file size and autogrowth
            foreach ($logfile in $db.logfiles) {
                $logfile.size = 524288
                $logfile.growth = 131072
                $logfile.growthtype = 'kb'
                $logfile.Alter()
                Write-LogEvent 'DB log file size configured to default settings' -Output
            }
            if ($SQLIntegrated) {
                #Add Integrated sql permissions for db
                Add-UserToRole -server $SqlInstance -Database $dbname -User "$env:USERDOMAIN\$env:USERNAME" -Role 'db_owner'
            } else {
                #create sql login for db
                Add-SqlLogin -LoginPSCredential $SQLOwnerAccount -LoginType 'SqlLogin' -Enable -GrantConnectSql
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLOwner -Role 'db_owner'
                Add-SqlLogin -LoginPSCredential $SQLSchedulerAccount -LoginType 'SqlLogin' -Enable -GrantConnectSql
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLScheduler -Role 'db_backupoperator'
                Add-SqlLogin -LoginPSCredential $SQLAppPoolAccount -LoginType 'SqlLogin' -Enable -GrantConnectSql
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLAppPool -Role 'db_datareader'
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLAppPool -Role 'db_datawriter'
            }
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    } else {
        Write-LogEvent 'No SQL Server PowerShell Modules found for automatic Database setup. Please run SQL Server setup manually.'
    }
}