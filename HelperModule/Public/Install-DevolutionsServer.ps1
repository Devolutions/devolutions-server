function Install-DevolutionsServer {
    [CmdletBinding(DefaultParameterSetName = 'GA')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'GA', Position = 0)][switch]$GA,
        [Parameter(Mandatory, ParameterSetName = 'LTS', Position = 0)][switch]$LTS,
        [parameter(Mandatory, HelpMessage = 'Include full format of your license key from email.', Position = 1)][string]$LicenseKey,
        [Parameter(Mandatory, HelpMessage = 'Email that will be stored on Devolutions Server first time login account.')]
        [string]$DevolutionsAdminEmail,
        [parameter(HelpMessage = 'Used to set Integrated security for both SQL and Devolutions Console', Position = 2)][switch]$IntegratedSecurity,        
        [parameter(HelpMessage = 'Used to install an SQL Server', Position = 3)][switch]$SQLServer,
        [parameter(HelpMessage = 'Used to install SQL Server Management Studio', Position = 4)][switch]$SSMS
    )
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $dvlszip = "$Scriptpath\Packages\DVLS.Instance.zip"

    New-EventSource

    if (Test-dotNet) {
        Write-LogEvent '.NET Framework 4.8 is not installed, please use Install-IISPrerequisites then rerun this command' -Output
        return
    }

    if (!($IntegratedSecurity)) {
        $SQLOwnerAccount = Get-Credential -Message 'Please enter the credentials you would like to use for your the Database Owner: '
        $SQLSchedulerAccount = Get-Credential -Message 'Please enter the credentials you would like to use for your the Scheduler Service: '
        $SQLAppPoolAccount = Get-Credential -Message 'Please enter the credentials you would like to use for your the App Pool: '
    }
    $DvlsAdminAccount = Get-Credential -Message "Please enter the credentials you would like to use for your Devolutions Admin Account: `nNote this is a custom account, not a Domain account"
    if (($SQLServer)) {
        if ($IntegratedSecurity) { Install-SqlServer -SQLIntegrated } else { Install-SqlServer -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount -SQLAppPoolAccount $SQLAppPoolAccount } 
    }
    if (($SSMS)) { Install-SqlStudio }

    if ($GA) { Install-DevolutionsConsole -GA }
    if ($LTS) { Install-DevolutionsConsole -LTS }

    if (Test-Network) {
        if (!(Test-DevoZip)) {
            if ($IntegratedSecurity) {
                New-ResponseFile -IntegratedSecurity -DevolutionsAdminAccount $DvlsAdminAccount -DevolutionsAdminEmail $DevolutionsAdminEmail -LicenseKey $LicenseKey -ZipFileLocation $dvlszip
            } else {
                New-ResponseFile -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount -DevolutionsAdminAccount $DvlsAdminAccount -DevolutionsAdminEmail $DevolutionsAdminEmail -LicenseKey $LicenseKey  -ZipFileLocation $dvlszip
            }
            if ($GA) { Invoke-DevolutionsZip -GA }
            if ($LTS) { Invoke-DevolutionsZip -LTS }
        } else {
            if ($IntegratedSecurity) {
                New-ResponseFile -IntegratedSecurity -DevolutionsAdminAccount $DvlsAdminAccount -DevolutionsAdminEmail $DevolutionsAdminEmail -LicenseKey $LicenseKey -ZipFileLocation $dvlszip
            } else {
                New-ResponseFile -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount -DevolutionsAdminAccount $DvlsAdminAccount -DevolutionsAdminEmail $DevolutionsAdminEmail -LicenseKey $LicenseKey -ZipFileLocation $dvlszip
            }
            Install-DevolutionsInstance
        }
    } elseif (!(Test-Network)) {
        if ((Test-DevoZip)) {
            if ($IntegratedSecurity) {
                New-ResponseFile -IntegratedSecurity -DevolutionsAdminAccount $DvlsAdminAccount -DevolutionsAdminEmail $DevolutionsAdminEmail -LicenseKey $LicenseKey -ZipFileLocation $dvlszip 
            } else {
                New-ResponseFile -SQLOwnerAccount $SQLOwnerAccount -SQLSchedulerAccount $SQLSchedulerAccount  -SQLAppPoolAccount $SQLAppPoolAccount -DevolutionsAdminAccount $DvlsAdminAccount -DevolutionsAdminEmail $DevolutionsAdminEmail -LicenseKey $LicenseKey -ZipFileLocation $dvlszip
            }
            Install-DevolutionsInstance
        } else {
            Write-LogEvent "Installation ZIP file for Devolutions Server Instance is not present on $env:COMPUTERNAME `nin $Scriptpath\Packages folder for offline installation.`n" -Output
            Write-LogEvent "Note: Due to SQL Express' constraints you will need to install SQL Server on the same or seperate server before installing Devolutions Server.`n" -Output
            Write-LogEvent "Please run New-OfflineServer on a network capable PC/Server,`nthen move files to your offline server.`n`nInstallation will now end." -Output
            return
        }
    }
}