function Install-SQLServer {
    param(
        [parameter(HelpMessage = 'Used to install SQL Server Management Studio')][switch]$SSMS,
        [parameter(HelpMessage = 'Used to set SQL Server to use Integrated security')][switch]$SQLIntegrated,
        [parameter(HelpMessage = 'Used to enable TCP on your SQL Server Configuration')][switch]$tcp,
        [parameter(HelpMessage = 'Used to enable Named Pipes on your SQL Server Configuration')][switch]$up

    )
    if (!(Test-Programs -Sql -ErrorAction:SilentlyContinue)) {
        
        if (!($SQLIntegrated)) {
            $SQLAccount = Get-Credential -Message 'Please enter the credentials you would like to use for your SQL Account: '
            $SQLUser = $SQLAccount.GetNetworkCredential().UserName
        }
        $path = "$PSScriptRoot\Programs"
        if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }

        #SQL Express install
        Write-LogEvent 'Downloading SQL Server Express...'
        $Installer = 'SQL-SSEI-Expr.exe'
        $URL = Get-RedirectedUrl -Url 'https://api.devolutions.net/redirection/ef88f312-606e-4a78-bff9-2177867f7a5b'
        try { Start-BitsTransfer $URL -Destination $path\$Installer } catch [System.Exception] { Write-LogEvent $_ -Errors }

        Write-LogEvent 'Installing SQL Server Express...'
        try {
            Start-Process -FilePath $Path\$Installer -Args '/ACTION=INSTALL /IACCEPTSQLSERVERLICENSETERMS /Q' -Verb RunAs -Wait 
            Write-LogEvent 'SQL Server Express installed' 
        } catch [System.Exception] { Write-LogEvent $_ -Errors }
        try {
            Remove-Item $path\$Installer 
            Write-LogEvent "Removing $path\$Installer from $Env:ComputerName"
        } catch [System.Exception] { Write-LogEvent $_ -Errors }


        #modules required for the DB creation and setting the login rights
        try {
            Install-PackageProvider -Name NuGet -Force
            if ( ! (Get-Module SqlServer )) {
                Write-LogEvent "SQLServer module not found on $env:ComputerName."
                Write-LogEvent 'Installing SQLServer module for PowerShell.'
                Install-Module -Name 'SqlServer' -Force
            }
            Import-Module -Name 'SqlServer'
            Write-LogEvent 'Imported SQLServer module for PowerShell.'
        } catch [System.Exception] { Write-LogEvent $_ -Errors }

        try {
            #set mixed mode for authentication
            $comp = $env:ComputerName
            $sql = [Microsoft.SqlServer.Management.Smo.Server]::new("$comp\SQLEXPRESS") 
            if ($SQLIntegrated) {
                $sql.Settings.LoginMode = 'Mixed'
            }
            $sql.Alter()
            try { Get-Service -Name 'MSSQL$SQLEXPRESS' | Restart-Service } catch [System.Exception] { Write-LogEvent $_ -Errors }


            #TODO Next Step: Add naming for more customizability
            # set instance and database name variables
            $dbname = 'DVLS'
            $Script:SqlInstance = 'localhost\SQLEXPRESS'
            $sqlServerName = 'SQLEXPRESS'

            # change to SQL Server instance directory
            Set-Location SQLSERVER:\SQL\$SqlInstance

            # create object and database
            $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $SqlInstance, $dbname
            $db.Create()
            Write-LogEvent "New database SQL Server located: $SqlInstance and Database Name: $dbname." -Output

            # set recovery model
            #TODO Next step: look at maintenance plans for DB recovery models
            $db.RecoveryModel = 'simple'
            $db.Alter()
            Write-LogEvent 'Recovery model is set to Simple. It is highly suggested to look at your maintenance plans for DB recoveries.' -Output

            # change owner
            if (!($SQLIntegrated)) {

                $db.SetOwner('sa')
                Write-LogEvent 'DB owner set to sa account.' -Output
            }

            # change data file size and autogrowth amount
            foreach ($datafile in $db.filegroups.files) {
                $datafile.size = 1048576
                $datafile.growth = 262144
                $datafile.growthtype = 'kb'
                $datafile.alter()
                Write-LogEvent 'DB autogrowth configured to default settings' -Output
            }

            # change log file size and autogrowth
            foreach ($logfile in $db.logfiles) {
                $logfile.size = 524288
                $logfile.growth = 131072
                $logfile.growthtype = 'kb'
                $logfile.alter()
                Write-LogEvent 'DB log file size configured to default settings' -Output
            }
            if ($SQLIntegrated) {
                Add-UserToRole -server $SqlInstance -Database $dbname -User "$env:USERDOMAIN\$env:USERNAME" -Role 'db_owner'
                Write-LogEvent "$env:USERDOMAIN\$env:USERNAME set as db_owner on $dbname in $SqlInstance" -Output
            } else {
                #create sql login for db
                Add-SqlLogin -LoginPSCredential $SQLAccount -LoginType 'SqlLogin' -Enable -GrantConnectSql
                Add-UserToRole -server $SqlInstance -Database $dbname -User $SQLUser -Role 'db_owner'
                Write-LogEvent "$SQLUser set as db_owner on $dbname in $SqlInstance" -Output
            }
        } catch [System.Exception] { Write-LogEvent $_ -Errors }


        if ($SSMS) { Install-SSMS }
    } else {
        Write-LogEvent 'SQL Server is already installed.'
        if ($SSMS) { Install-SSMS }
    }
    try {
        $smo = 'Microsoft.SqlServer.Management.Smo.'
        $wmi = New-Object ($smo + 'Wmi.ManagedComputer').

        # Enable the TCP protocol on the default instance.
        if ($tcp) {
            Write-EventLog 'Enabling TCP Protocol on Sql Server'
            $uri = "ManagedComputer[@Name='" + $env:COMPUTERNAME + "']/ServerInstance[@Name='" + $sqlServerName + "']/ServerProtocol[@Name='Tcp']"
            $Tcp = $wmi.GetSmoObject($uri)
            $Tcp.IsEnabled = $true
            $Tcp.Alter()
            $Tcp
        }
        # Enable the named pipes protocol for the default instance.
        if ($np) {
            Write-EventLog 'Enabling Named Pipes Protocol on Sql Server'
            $uri = "ManagedComputer[@Name='" + $env:COMPUTERNAME + "']/ServerInstance[@Name='" + $sqlServerName + "']/ServerProtocol[@Name='Np']"
            $Np = $wmi.GetSmoObject($uri)
            $Np.IsEnabled = $true
            $Np.Alter()
            $Np
        }
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
}