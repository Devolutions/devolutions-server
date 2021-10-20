#Requires -RunAsAdministrator
Set-StrictMode -Version 1.0

$ModuleName = $(Get-Item $PSCommandPath).BaseName
$Manifest = Import-PowerShellDataFile -Path $(Join-Path $PSScriptRoot "${ModuleName}.psd1")

Export-ModuleMember -Cmdlet @($manifest.CmdletsToExport)

$Public = @(Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1" -Recurse)
$Private = @(Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1" -Recurse | Where-Object { $_.FullName -inotmatch 'enums' })

foreach ($Import in @($Public + $Private)) {
    try {
        . $Import.FullName 
    } catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

foreach ($file in $Public) {
    Export-ModuleMember -Function $file.BaseName
}