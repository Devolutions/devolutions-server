
function Invoke-DevolutionsConsole {
    [CmdletBinding(DefaultParameterSetName = 'GA')]
    param (
        [Parameter(ParameterSetName = 'GA', Position = 0)][switch]$GA,
        [Parameter(ParameterSetName = 'LTS', Position = 0)][switch]$LTS
    )
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    if ($GA) { $Pattern = 'DPSConsole.Exe' }
    if ($LTS) { $Pattern = 'DPSConsoleLts.Exe' }
    $source = (Get-DevolutionsLinks -Pattern $Pattern).Trim()
    $destination = "$path\Setup.DPS.Console.exe"
    if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }

    try {
        Write-LogEvent 'Downloading Devolutions Server Console'
        Start-BitsTransfer $source -Destination $destination
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
    Install-DevoConsole
}