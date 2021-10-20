function Invoke-DevolutionsZip {
    $Scriptpath = Split-Path -Path $PSScriptRoot -Parent
    $path = "$Scriptpath\Packages"
    if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }
    if ($GA) { $Pattern = 'DPS.Url' }
    if ($LTS) { $Pattern = 'DPSLts.Url' }
    $source = (Get-DevolutionsLinks -Pattern $Pattern).Trim()
    $destination = "$path\DVLS.Instance.zip"

    try {
        Write-LogEvent 'Downloading Devolutions Server Instance zip'
        Start-BitsTransfer $source -Destination $destination
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
    Install-DevolutionsInstance
}