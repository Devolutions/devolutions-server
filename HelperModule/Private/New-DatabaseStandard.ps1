function New-DatabaseStandard {
    [CmdletBinding(DefaultParameterSetName = 'SQLAccounts')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'SQLAccounts', Position = 0)]
        [System.Management.Automation.PSCredential]$SQLOwnerAccount,

        [Parameter(ParameterSetName = 'SQLAccounts', Position = 1)]
        [System.Management.Automation.PSCredential]$SQLSchedulerAccount,
    
        [Parameter(ParameterSetName = 'SQLAccounts', Position = 2)]
        [System.Management.Automation.PSCredential]$SQLAppPoolAccount,

        [parameter(Mandatory, ParameterSetName = 'Integrated', HelpMessage = 'Used to set SQL Server to use Integrated security', Position = 0)]
        [switch]$SQLIntegrated
    )
    New-EventSource

    #modules required for the DB creation and setting the login rights
    Install-PSModules
    if (Get-Module SqlServer) {
        if (!($SQLIntegrated)) {
            $SQLOwner = $SQLOwnerAccount.GetNetworkCredential().UserName
            $SQLScheduler = $SQLSchedulerAccount.GetNetworkCredential().UserName
            $SQLAppPool = $SQLAppPoolAccount.GetNetworkCredential().UserName
        }
        # DB Installation Standard
        try {
            $comp = $env:ComputerName
            $sql = [Microsoft.SqlServer.Management.Smo.Server]::new("$comp\SQLEXPRESS")
            # Set authentication mode
            if ($SQLIntegrated) {
                $sql.Settings.LoginMode = 'Integrated'
            } else { $sql.Settings.LoginMode = 'Mixed' }
            $sql.Alter()
            try { Get-Service -Name 'MSSQL$SQLEXPRESS' | Restart-Service } catch [System.Exception] { Write-LogEvent $_ -Errors }

            # Set instance and database name variables
            $dbname = 'DVLS'
            $Script:SqlInstance = 'localhost\SQLEXPRESS'

            # change to SQL Server instance directory
            Set-Location SQLSERVER:\SQL\$SqlInstance

            # create object and database
            $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $SqlInstance, $dbname
            $db.Create()
            Write-LogEvent "New database SQL Server located: $SqlInstance and Database Name: $dbname." -Output

            # set recovery model
            $db.RecoveryModel = 'simple'
            $db.Alter()
            Write-LogEvent 'Recovery model is set to Simple. It is highly suggested to look at your maintenance plans for DB recoveries.' -Output

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
                Write-LogEvent 'DB autogrowth configured with default settings' -Output
            }

            # change log file size and autogrowth
            foreach ($logfile in $db.logfiles) {
                $logfile.size = 524288
                $logfile.growth = 131072
                $logfile.growthtype = 'kb'
                $logfile.Alter()
                Write-LogEvent 'DB log file size configured with default settings' -Output
            }
            $Svr = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $SqlInstance
            #SQL DB Permissions
            if ($SQLIntegrated) {
                #Add Integrated sql permissions for db
                $svrole = $Svr.Roles | Where-Object {$_.Name -eq 'sysadmin'}
                $svrole.AddMember("$env:USERDOMAIN\$env:USERNAME")
                Write-LogEvent "$env:USERDOMAIN\$env:USERNAME was added to sysadmin Server Roles" -Output
                Add-UserToRole -server $SqlInstance -Database $dbname -User "$env:USERDOMAIN\$env:USERNAME" -Role 'db_owner'
            } else {
                #create sql login for db
                Add-SqlLogin -LoginPSCredential $SQLOwnerAccount -LoginType 'SqlLogin' -Enable -GrantConnectSql
                $svrole = $Svr.Roles | Where-Object {$_.Name -eq 'sysadmin'}
                $svrole.AddMember($SQLOwner)
                Write-LogEvent "$SQlOwnerAccount was added to sysadmin Server Roles" -Output
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLOwner -Role 'db_owner'
                Add-SqlLogin -LoginPSCredential $SQLSchedulerAccount -LoginType 'SqlLogin' -Enable -GrantConnectSql
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLScheduler -Role 'db_backupoperator'
                Add-SqlLogin -LoginPSCredential $SQLAppPoolAccount -LoginType 'SqlLogin' -Enable -GrantConnectSql
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLAppPool -Role 'db_datareader'
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLAppPool -Role 'db_datawriter'
            }
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    } else {
        Write-LogEvent 'No No SQL Server PowerShell Modules found for manual Database setup. Please run SQL Server setup manually.'
    }
}