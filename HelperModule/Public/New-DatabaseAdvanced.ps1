﻿function New-DatabaseAdvanced {
    param(
        [parameter(Mandatory, HelpMessage = 'Used to set SQL Database Name')][string]$DatabaseName,
        [parameter(HelpMessage = 'Used to set SQL Server to use Integrated security')][switch]$SQLIntegrated,
        [parameter(Mandatory, HelpMessage = 'SQL Database Recovery model setting.')]
        [ValidateSet('BulkLogged', 'Full', 'Simple')][string]$RecoveryModel

    )
    New-EventSource
    #modules required for the DB creation and setting the login rights
    Install-PSModules
    if (!(Get-Module SqlServer)) {
        if (!($SQLIntegrated)) {
            $SQLAccount = Get-Credential -Message 'Please enter the credentials you would like to use for your SQL Account: '
            $SQLUser = $SQLAccount.GetNetworkCredential().UserName
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
            $SqlInstance = "localhost\SQLEXPRESS"

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
                Add-UserToRole -server $SqlInstance -Database $dbname -User "$env:USERDOMAIN\$env:USERNAME" -Role 'db_owner'
                Write-LogEvent "$env:USERDOMAIN\$env:USERNAME set as db_owner on $dbname in $SqlInstance" -Output
            } else {
                #create sql login for db
                Add-SqlLogin -LoginPSCredential $SQLAccount -LoginType 'SqlLogin' -Enable -GrantConnectSql
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLUser -Role 'db_owner'
            }
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
    } else {
        Write-LogEvent 'No SQL Server PowerShell Modules found for automatic Database setup. Please run SQL Server setup manually.'
    }
}