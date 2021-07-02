function Install-PrerequisiteServer {
    param ([string]$serverRole)
    Write-LogEvent "Checking status of $serverRole"
    if ((Get-WindowsFeature -Name $serverRole).Installed -eq $false) {
        Write-LogEvent "Installing $serverRole"
        $install = Install-WindowsFeature -Name $serverRole -IncludeManagementTools
        if ($install.Success) {
            Write-LogEvent "$serverRole installed successfully"
        } else {
            Write-LogEvent $install.ExitCode
        }
    } else { Write-LogEvent "$serverRole is already installed" }
}