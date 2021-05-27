if (Get-Module -ListAvailable -Name serverManager) {Import-Module serverManager} else {Install-Module serverManager}
function Get-SQLDatabaseVer {
    param (
        [parameter(Mandatory=$true)][string]$DVLSpath
    )
    Set-Location "C:\Program Files (x86)\Devolutions\Devolutions Server Console\"
    .\DPS.Console.CLI.exe server db get-version --dps-path=$DVLSpath 
}
function Get-ConsoleVersion {
    Set-Location "C:\Program Files (x86)\Devolutions\Devolutions Server Console\"
    .\DPS.Console.CLI.exe version     
}
function Install-NewServer {
    param (
        [parameter(Mandatory=$true)][string]$SQLAccount,
        [parameter(Mandatory=$true)][string]$SQLPassword,
        [parameter(Mandatory=$true)][string]$ConsoleVersion
    )
    $Path = $env:TEMP

    Install-SQL -SQLInstall $true -SSMS $true -SQLAccount $SQLAccount -SQLPassword $(ConvertTo-SecureString $SQLPassword -AsPlainText -Force)
    
    Install-DVLSConsole -ConsoleVersion $ConsoleVersion

    $response =@'
{
"accept-eula": true,
"admin-email": "Change@me.com",
"admin-password": "Change ME",
"admin-username": "Change ME",
"app-pool-identity-type": "NetworkService",
"app-pool-name": "dvls",
"appPoolPassword": null,
"app-pool-identity-username": null,
"backup-keys-password": "Change ME",
"backup-keys-path": "C:\\DPS Key Backup\\DVLS\\",
"command": "server install",
"console-pwd": null,
"database-console-password": null,
"database-console-username": null,
"database-host": "localhost\\SQLEXPRESS",
"database-integrated-security": true,
"database-name": "DVLS",
"database-scheduler-password": null,
"database-scheduler-username": null,
"database-username": null,
"database-vault-password": null,
"database-vault-username": null,
"debug": false,
"description": null,
"disable-encrypt-config": false,
"disable-https": true,
"disable-password": true,
"dps-path": "C:\\inetpub\\wwwroot\\dvls",
"dps-website-name": "Default Web Site",
"install-zip": null,
"quiet": true,
"scheduler": true,
"server-name": "Devolutions Server",
"server-serial-key": "Enter Serial key here",
"service-account": "LocalSystem",
"servicePassword": null,
"service-user": null,
"verbose": true,
"web-application-name": "/dvls"  
}
'@
        $response | out-file $Path\response.json
    Write-Host "You can now run a Install-DVLSInstance. Before doing so, please edit Response file with needed information. `nFile will be opened." -ForegroundColor Red -BackgroundColor Black
    Start-Process notepad "$path\response.json" -Wait
    Install-DVLSInstance
}
function Install-SQL {
    param(
        [parameter(Mandatory=$true)][bool]$SQLInstall,
        [parameter(Mandatory=$false)][bool]$SSMS,
        [parameter(Mandatory=$false)][bool]$SQLIntegrated,
        [parameter(Mandatory=$true)][string]$SQLAccount,
        [parameter(Mandatory=$true)][securestring]$SQLPassword
    )
    try {
        $Path = $env:TEMP

        #SQL Express install
        if ($SQLInstall) {
            Write-Host "Downloading SQL Server Express 2019..."
            $Installer = "SQL2019-SSEI-Expr.exe"
            $URL = "https://go.microsoft.com/fwlink/?linkid=866658"
            Start-BitsTransfer $URL -Destination $Path\$Installer
        
            Write-Host "Installing SQL Server Express..."
            Start-Process -FilePath $Path\$Installer -Args "/ACTION=INSTALL /IACCEPTSQLSERVERLICENSETERMS /Q" -Verb RunAs -Wait
            Remove-Item $Path\$Installer
            #modules required for the DB creation and setting the login rights
            Install-PackageProvider -Name NuGet -Force
            if ( ! (Get-Module SqlServer )) {
                Install-Module -Name "SqlServer" -Force
            }
            if ( ! (Get-Module dbatools )) {
                Install-Module -Name "dbatools" -Force
            }
            Import-Module -Name "dbatools"
            #set mixed mode for authentication
            $comp = $env:ComputerName
            $sql = [Microsoft.SqlServer.Management.Smo.Server]::new("$comp\SQLEXPRESS")
            $sql.Settings.LoginMode = 'Mixed'
            $sql.Alter()
            Get-Service -Name 'MSSQL$SQLEXPRESS' | Restart-Service

            #create database
            $SqlInstance = 'localhost\SQLEXPRESS'                                                  # SQL Server name 
            $Name = 'DVLS'                                                                         # database name
            $DataFilePath = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\' # data file path
            $LogFilePath = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\'  # log file path
            $Recoverymodel = 'Simple'                                                              # recovery model
            $Owner = 'sa'                                                                          # database owner
            $PrimaryFilesize = 1024                                                                # data file initial size
            $PrimaryFileGrowth = 256                                                               # data file autrogrowth amount
            $LogSize = 512                                                                         # data file initial size
            $LogGrowth = 128                                                                       # data file autrogrowth amount

            New-DbaDatabase -SqlInstance $SqlInstance -Name $Name -DataFilePath $DataFilePath -LogFilePath $LogFilePath -Recoverymodel $Recoverymodel -Owner $Owner -PrimaryFilesize $PrimaryFilesize -PrimaryFileGrowth $PrimaryFileGrowth -LogSize $LogSize -LogGrowth $LogGrowth | Out-Null

            if ($SQLIntegrated){
                Invoke-Sqlcmd -ServerInstance $SqlInstance -Database $Name -Query "exec ('CREATE LOGIN ['$SQLAccount'] FROM WINDOWS');"
                Invoke-Sqlcmd -ServerInstance $SqlInstance -Database $Name -Query "exec ('ALTER LOGIN ['$SQLAccount'] ENABLE');"
                Invoke-Sqlcmd -ServerInstance $SqlInstance -Database $Name -Query "exec('CREATE USER ['$SQLAccount'] FOR LOGIN ['$SQLAccount']');"
                Invoke-Sqlcmd -ServerInstance $SqlInstance -Database $Name -Query "exec sp_addrolemember 'db_owner', $SQLAccount;"
            }else {
                #create sql login for db
                $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $SQLAccount, $SQLPassword
                New-DbaLogin -SqlInstance $SqlInstance -Login $cred.UserName -SecurePassword $cred.Password
                Invoke-Sqlcmd -ServerInstance $SqlInstance -Database $Name -Query "CREATE USER [$SQLAccount] FOR LOGIN [$SQLAccount];"
                Invoke-Sqlcmd -ServerInstance $SqlInstance -Database $Name -Query "exec sp_addrolemember 'db_owner', $SQLAccount;"
            }

        }
        if ($SSMS){Install-SSMS}
    }
    catch {
        Write-Host "An error occurred:"
        Write-Host $_
    }
}
function Install-SSMS {
    $SQLStudio = "https://aka.ms/ssmsfullsetup"
    $tempInstaller = "$env:temp\SSMSinstaller.exe"
    Write-Host "Downloading SSMS..."
    Start-BitsTransfer $SQLStudio -Destination $tempInstaller
    Write-Host "Installing SSMS..."
    Set-Location $env:temp
    Start-Process -FilePath $tempInstaller -Args "/install /quiet /norestart" -Verb RunAs -Wait
    Write-Host "SSMS installed"
    Remove-Item $tempInstaller
}
function Install-DVLSConsole {
    param(
        [parameter(Mandatory=$true)][string]$ConsoleVersion
    )
    try{
        $Path = $env:TEMP
            if(!(Test-Path "C:\Program Files (x86)\Devolutions\Devolutions Server Console\DPS.Console.UI.exe")){
        #Install-DVLSConsole {
        Write-Host "Downloading DVLS Console..."
        $Installer = "Setup.DPS.Console.$ConsoleVersion.exe"
        $URL = "https://cdn.devolutions.net/download/$Installer"
        Start-BitsTransfer $URL -Destination $Path\$Installer

        Write-Host "Installing DVLS Console..."
        Start-Process -FilePath $Path\$Installer -Args "/qn" -Verb RunAs -Wait
        Remove-Item $Path\$Installer
        
        #Shortcut for DVLS
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut("$Home\Desktop\DVLS Console.lnk")
        $Shortcut.TargetPath = "C:\Program Files (x86)\Devolutions\Devolutions Server Console\DPS.Console.UI.exe"
        $Shortcut.Save()
        }
        else {
            Write-Host "DVLS Console is already installed."
        }
    }
    catch {
        Write-Host "An error occurred:"
        Write-Host $_
    }
}
function Install-Prerequisite {
    param (
        [parameter(Mandatory=$false)][bool]$InstallPrerequisites
    )
    if ($InstallPrerequisites){
        function Install-PrerequisiteServer ()
        {
            param ([string]$serverRole)
            Write-Log "Checking status of $serverRole"
            if ((Get-WindowsFeature -Name $serverRole).Installed -eq $false)
            {
                Write-Log "Installing $serverRole"
                $install = Install-WindowsFeature -Name $serverRole -IncludeManagementTools
                if ($install.Success)
                {
                    Write-Host "$serverRole successfully installed"
                    Write-Log "$serverRole installed successfully"
                }
                else
                {
                    Write-Log "$serverRole installation error"
                    Write-Host $install.ExitCode
                }
            }
        }

        function Install-PrerequisiteDesktop ()
        {
            param ([string]$serverRole)
            Write-Log "Checking status of $serverRole"
            if ((Get-WindowsOptionalFeature -Online -FeatureName $serverRole).state -eq "Disabled")
            {
                Write-Log "Installing $serverRole"
                $install = Enable-WindowsOptionalFeature -Online -FeatureName $serverRole -all
                if ($install.Success)
                {
                    Write-Log "$serverRole installed successfully"
                    Write-Host "$serverRole successfully installed"
                }
                else
                {
                    Write-Log "$serverRole installation error"
                    Write-Host $install.ExitCode
                }
            }
        }

        function Install-IisUrlRewrite ()
        {
            [CmdletBinding(SupportsShouldProcess = $true)]
            Param()
            Write-Log 'Install-IisUrlRewrite begin...'

            $ExitCode = 0
            # Do nothing if URL Rewrite module is already installed
            if (Test-Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\URL Rewrite\')
            {
                $URregkey = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\URL Rewrite\'
                if ($URregkey.Version -ge 7.1)
                {
                    Write-Verbose "URL Rewrite module is already installed"
                    Write-Log "URL Rewrite module is already installed"
                    return
                }
            }
            Write-Host "Installing IIS URL Rewrite Module"
            Write-Log "Installing IIS URL Rewrite Module"
            
            $url1 = "$env:TEMP\rewrite_amd64_en-US.msi"
            Invoke-Webrequest -Uri https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi -OutFile $url1
            $Exitcode = (Start-Process -FilePath "msiexec.exe" -ArgumentList "/I $url1 /q" -Wait -Passthru).ExitCode
            Remove-Item $url1 -Recurse

            if ($ExitCode -ne 0 -and $ExitCode -ne 1641 -and $ExitCode -ne 3010)
            {
                Write-Log "Failed to install IIS URL Rewrite 2.0 Module (Result=$ExitCode)."
                Write-Error "Failed to install IIS URL Rewrite 2.0 Module (Result=$ExitCode)."
            }
            else 
            {
                Write-Log "Installation of IIS URL Rewrite 2.0 Module finished!"
                Write-Verbose "Installation of IIS URL Rewrite 2.0 Module finished!"    
            }
        }

        function Install-Net472Core ()
        {
            # Do nothing if .net 472 is already installed
            if (Test-Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' )
            {
                $vnet = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\'
                if ($vnet.Release -eq 461814)
                {
                    Write-Verbose ".Net Framework is already installed"
                    return
                }
            }

            # Installing .Net Framework 4.7.2
            $ExitCode = 0
            $net472 ="$env:TEMP\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
            Write-Log "Downloading .net 4.7.2."
            Write-verbose "Download .NET framework"
            Invoke-Webrequest -Uri https://go.microsoft.com/fwlink/?LinkId=863265 -OutFile $net472
            Write-Host "Installing .Net Framework 4.7.2"
            Write-Log "Installing .Net Framework 4.7.2"
            $ExitCode = (Start-Process -FilePath "msiexec.exe" -ArgumentList "/I $net472 /q" -Wait -Passthru).ExitCode
            Remove-Item $net472 -Recurse

            if ($ExitCode -ne 0 -and $ExitCode -ne 1641 -and $ExitCode -ne 3010)
            {
                Write-Error "Failed to install .Net Framework (Result=$ExitCode)."
                Write-Log "Failed to install .Net Framework (Result=$ExitCode)."
            }
            else 
            {
                Write-Verbose "Installation of .Net Framework finished!"    
                Write-Log "Installation of .Net Framework finished!"    
            }
        }

        function Create-EventSource()
        {
            New-EventLog -LogName 'Application' -Source 'DVLS-Prerequisites-Script'
        }

        function Write-Log([string]$Message)
        {
            Write-EventLog -LogName 'Application' -Source 'DVLS-Prerequisites-Script' -EntryType 'Information' -EventID 1 -Message $Message
        }

        Create-EventSource

        $regKey = "hklm:/software/microsoft/windows nt/currentversion" 
        $Core = (Get-ItemProperty $regKey).InstallationType -eq "Server Core"

        $machineType = Get-WmiObject win32_operatingsystem
        if ($machineType.ProductType -eq 2 -or $machineType.ProductType -eq 3)
        {
            Import-Module ServerManager
            Install-PrerequisiteServer "Web-Server"
            Install-PrerequisiteServer "Web-Http-Errors"
            Install-PrerequisiteServer "Web-Http-Logging"
            Install-PrerequisiteServer "Web-Static-Content"
            Install-PrerequisiteServer "Web-Default-Doc"
            Install-PrerequisiteServer "Web-Dir-Browsing"
            Install-PrerequisiteServer "Web-AppInit"
            Install-PrerequisiteServer "Web-Net-Ext45"
            Install-PrerequisiteServer "Web-Asp-Net45"
            Install-PrerequisiteServer "Web-ISAPI-Ext"
            Install-PrerequisiteServer "Web-ISAPI-Filter"
            Install-PrerequisiteServer "Web-Basic-Auth"
            Install-PrerequisiteServer "Web-Digest-Auth"
            Install-PrerequisiteServer "Web-Stat-Compression"
            Install-PrerequisiteServer "Web-Windows-Auth"   
        }
            else
        {
            Install-PrerequisiteDesktop "IIS-WebServer"
            Install-PrerequisiteDesktop "IIS-HttpErrors"
            Install-PrerequisiteDesktop "IIS-HttpLogging"
            Install-PrerequisiteDesktop "IIS-StaticContent"
            Install-PrerequisiteDesktop "IIS-DefaultDocument"
            Install-PrerequisiteDesktop "IIS-DirectoryBrowsing"
            Install-PrerequisiteDesktop "IIS-ApplicationInit"
            Install-PrerequisiteDesktop "IIS-NetFxExtensibility45"
            Install-PrerequisiteDesktop "IIS-ASPNET45"
            Install-PrerequisiteDesktop "IIS-ISAPIExtensions"
            Install-PrerequisiteDesktop "IIS-ISAPIFilter"
            Install-PrerequisiteDesktop "IIS-BasicAuthentication"
            Install-PrerequisiteDesktop "IIS-HttpCompressionStatic"
        }

        $internetAccess = Test-NetConnection -ComputerName "go.microsoft.com" -WarningAction SilentlyContinue
        if ($internetAccess.PingSucceeded)
        {

            if ($Core -eq $true)
            {
                $net472_start = Get-Date
                Install-Net472Core
                $net472_time = Get-Date
                Write-Output "Time taken: $(($net472_time).Subtract($net472_start).Seconds) second(s)"
            }

            $url_start = Get-Date
            Install-IisUrlRewrite
            $url_time = Get-Date
            Write-Output "Time taken: $(($url_time).Subtract($url_start).Seconds) second(s)"
        }
        else
        {
            Write-Host 
            Write-Host 
            Write-Host "An internet access is required to download URL Rewrite Module and .Net Framework." -ForegroundColor Red
            Write-Host "Here are the download pages for these two prerequisites :" -ForegroundColor Red
            Write-Host "URL Rewrite Module : " -NoNewline -ForegroundColor Yellow
            Write-Host "https://www.microsoft.com/en-ca/download/details.aspx?id=47337" 
            Write-Host ".Net Framework 4.7.2 for Server Core : " -NoNewline -ForegroundColor Yellow
            Write-Host "https://go.microsoft.com/fwlink/?LinkId=863265"
            Write-Host
            Write-Host 
            Write-Host 
        }
    }
}
function Install-DVLSInstance{
    param(
        [parameter(Mandatory=$false)][bool]$InstanceInstall
    )
    $Path = $env:TEMP
    Set-Location "C:\Program Files (x86)\Devolutions\Devolutions Server Console"

    if (!(Get-WindowsFeature -Name Web-Server).Installed){

        Install-Prerequisite -InstallPrerequisites $true
    }
    
    #Response file to install the DVLS Instance
    if (!(test-path $Path\response.json)){
$response =@'
{
"accept-eula": true,
"admin-email": "Change@me.com",
"admin-password": "Change ME",
"admin-username": "Change ME",
"app-pool-identity-type": "NetworkService",
"app-pool-name": "dvls",
"appPoolPassword": null,
"app-pool-identity-username": null,
"backup-keys-password": "Change ME",
"backup-keys-path": "C:\\DPS Key Backup\\DVLS\\",
"command": "server install",
"console-pwd": null,
"database-console-password": null,
"database-console-username": null,
"database-host": "localhost\\SQLEXPRESS",
"database-integrated-security": true,
"database-name": "DVLS",
"database-scheduler-password": null,
"database-scheduler-username": null,
"database-username": null,
"database-vault-password": null,
"database-vault-username": null,
"debug": false,
"description": null,
"disable-encrypt-config": false,
"disable-https": true,
"disable-password": true,
"dps-path": "C:\\inetpub\\wwwroot\\dvls",
"dps-website-name": "Default Web Site",
"install-zip": null,
"quiet": true,
"scheduler": true,
"server-name": "Devolutions Server",
"server-serial-key": "Enter Serial key here",
"service-account": "LocalSystem",
"servicePassword": null,
"service-user": null,
"verbose": true,
"web-application-name": "/dvls"  
}
'@
        $response | out-file $Path\response.json
        Write-Host "Please edit Response file with needed information." -ForegroundColor Red -BackgroundColor Black
        Start-Process notepad $Path\response.json -Wait
        .\DPS.Console.CLI.exe @$path\response.json --verbose
        Remove-Item $path\response.json
    }else{.\DPS.Console.CLI.exe @$path\response.json --verbose
        Remove-Item $path\response.json
        
    }
    Write-Host "Installation complete. If instance is set to Force HTTP(S) True then you will need to set the certificate and Bindings" -ForegroundColor Red -BackgroundColor Black
}
function Update-DVLSInstance{
    param (
        [parameter(Mandatory=$true)][string]$DVLSpath,
        [parameter(Mandatory=$false)][SecureString]$ConsolePassword="",
        [parameter(Mandatory=$false)][string]$ZIPPath=""
    )
    if($UpdateDVLS){
        if ($null -eq $ConsolePassword -and $null -eq $ZIPPath){
            Set-Location 'C:\Program Files (x86)\Devolutions\Devolutions Server Console\'
            .\DPS.Console.CLI.exe server upgrade --dps-path=$DVLSpath --accept-eula --quiet --verbose    
        }
        elseif ($null -eq $ConsolePassword -and $null -ne $ZIPPath) {
            Set-Location 'C:\Program Files (x86)\Devolutions\Devolutions Server Console\'
            .\DPS.Console.CLI.exe server upgrade --dps-path=$DVLSpath --upgrade-zip=$ZIPPath --accept-eula --quiet --verbose}
        }         
        elseif ($null -ne $ConsolePassword -and $null -eq $ZIPPath) {
            Set-Location 'C:\Program Files (x86)\Devolutions\Devolutions Server Console\'
            .\DPS.Console.CLI.exe server upgrade --dps-path=$DVLSpath --console-pwd=$ConsolePassword --accept-eula --quiet --verbose
        }
        else {
            Set-Location 'C:\Program Files (x86)\Devolutions\Devolutions Server Console\'
            .\DPS.Console.CLI.exe server upgrade --dps-path=$DVLSpath --console-pwd=$ConsolePassword --upgrade-zip=$ZIPPath --accept-eula --quiet --verbose
        }
}
function Update-SQLDatabase {
    param (
        [parameter(Mandatory=$true)][string]$DVLSpath
    )
    Set-Location "C:\Program Files (x86)\Devolutions\Devolutions Server Console\"
    .\DPS.Console.CLI.exe server db update --dps-path=$DVLSpath --verbose
} 