function Install-DevolutionsServer {
    [CmdletBinding(DefaultParameterSetName = 'GA')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'GA', Position = 0)][switch]$GA,
        [Parameter(Mandatory, ParameterSetName = 'LTS', Position = 0)][switch]$LTS,
        [parameter(HelpMessage = 'Used to set Integrated security for both SQL and Devolutions Console', Position = 2)][switch]$IntegratedSecurity,
        [parameter(HelpMessage = 'Used to install an SQL Server', Position = 3)][switch]$SQLServer,
        [parameter(HelpMessage = 'Used to install SQL Server Management Studio', Position = 4)][switch]$SSMS,
        [parameter(HelpMessage = 'Disables the use of HTTP(s) on your Devolutions Server.', Position = 5)][switch]$DisableHttps,
        [parameter(Mandatory, HelpMessage = 'Include full format of your license key from email.', Position = 1)][string]$LicenseKey
    )
    <#
    #Handles missing SQL and SSMS switches in case of user error
    if (!($SQLServer) -and !($SSMS)) {
        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&MS SQL Server'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&SQL Studio'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Both'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&None'))

        $decision = $Host.UI.PromptForChoice('SQL Installation Choices', 'Do you want to install MS SQL Server, MS SQL Server Management Studio, Both or None?', $choices, 2)

        if ($decision -eq 0) { $SQLServer = $true }
        if ($decision -eq 1) { $SSMS = $true }
        if ($decision -eq 2) {
            $SQLServer = $true
            $SSMS = $true
        }
    }#>
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $dvlszip = "$Scriptpath\Packages\DVLS.Instance.zip"

    New-EventSource

    if (($SQLServer)) { if ($IntegratedSecurity) { Install-SqlServer -SQLIntegrated } else { Install-SqlServer } }
    if (($SSMS)) { Install-SqlStudio }

    if ($GA) { Install-DevolutionsConsole -GA }
    if ($LTS) { Install-DevolutionsConsole -LTS }

    if (Test-Network) {
        if (!(Test-DevoZip)) {
            if ($IntegratedSecurity) {
                if ($DisableHttps) { New-ResponseFile -IntegratedSecurity -LicenseKey $LicenseKey -DisabledHttps -ZipFileLocation $dvlszip }
                else { New-ResponseFile -IntegratedSecurity -LicenseKey $LicenseKey -ZipFileLocation $dvlszip }
            } else {
                if ($DisableHttps) { New-ResponseFile -LicenseKey $LicenseKey -DisabledHttps -ZipFileLocation $dvlszip }
                else { New-ResponseFile -LicenseKey $LicenseKey -ZipFileLocation $dvlszip }
            }
            if ($GA) { Invoke-DevolutionsZip -GA }
            if ($LTS) { Invoke-DevolutionsZip -LTS }
        } else {
            if ($IntegratedSecurity) {
                if ($DisableHttps) { New-ResponseFile -IntegratedSecurity -LicenseKey $LicenseKey -DisabledHttps -ZipFileLocation $dvlszip }
                else { New-ResponseFile -IntegratedSecurity -LicenseKey $LicenseKey -ZipFileLocation $dvlszip }
            } else {
                if ($DisableHttps) { New-ResponseFile -LicenseKey $LicenseKey -DisabledHttps -ZipFileLocation $dvlszip } else {
                    New-ResponseFile -LicenseKey $LicenseKey -ZipFileLocation $dvlszip
                }
            }
            Install-DevolutionsInstance
        }
    } elseif (!(Test-Network)) {
        if ((Test-DevoZip)) {
            if ($IntegratedSecurity) {
                if ($DisableHttps) { New-ResponseFile -IntegratedSecurity -LicenseKey $LicenseKey -DisabledHttps -ZipFileLocation $dvlszip }
                else { New-ResponseFile -IntegratedSecurity -LicenseKey $LicenseKey -ZipFileLocation $dvlszip }
            } else {
                if ($DisableHttps) { New-ResponseFile -LicenseKey $LicenseKey -DisabledHttps -ZipFileLocation $dvlszip } else {
                    New-ResponseFile -LicenseKey $LicenseKey -ZipFileLocation $dvlszip
                }
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