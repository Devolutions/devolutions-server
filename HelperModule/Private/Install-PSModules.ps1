function Install-PSModules {
    $nuGet = Test-Path -Path 'C:\Program Files\PackageManagement\ProviderAssemblies\nuget\2.8.5.208\Microsoft.PackageManagement.NuGetProvider.dll'
    $SQLmod = Get-InstalledModule -Name SQlServer -ErrorAction:SilentlyContinue
    if (Test-Network) {
        if (!($nuGet)) {
            try { Install-PackageProvider -Name NuGet -Force -Confirm:$False } catch [System.Exception] { Write-LogEvent $_ -Errors }
        }
        if ($null -eq $SQLmod) {
            try {
                Write-LogEvent "SQLServer module not found on $env:ComputerName."
                Write-LogEvent 'Installing SQLServer module for PowerShell.'
                Install-Module -Name 'SqlServer' -Force -Confirm:$False
                Import-Module -Name 'SqlServer'
                Write-LogEvent 'Imported SQLServer module for PowerShell.'
            } catch [System.Exception] { Write-LogEvent $_ -Errors }
        }
    } else {
        Write-LogEvent 'You do not have internet access to install Modules or we are unable to find local files on your system.'
        Write-LogEvent 'Database will not be configured, this must be done manually.' -Output
    }
}