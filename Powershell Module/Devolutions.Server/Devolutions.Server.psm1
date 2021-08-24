Set-StrictMode -Version 1.0

$ModuleName = $(Get-Item $PSCommandPath).BaseName
$Manifest = Import-PowerShellDataFile -Path $(Join-Path $PSScriptRoot "${ModuleName}.psd1")

Export-ModuleMember -Cmdlet @($manifest.CmdletsToExport)

$Public = @(Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1" -Recurse)
$Private = @(Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1" -Recurse | Where-Object { $_.FullName -inotmatch 'enums' })
$Deprecate = @(Get-ChildItem -Path "$PSScriptRoot/Deprecate/*.ps1" -Recurse)
$Enums = @(Get-ChildItem -Path "$PSScriptRoot/Private/Types/enums/*.ps1" -Recurse)

#Load enums as types before loading cmdlets
foreach ($Enum in $Enums) {
    $FileContent = Get-Content $Enum.FullName
    [object[]]$typedef = [object[]]::new($FileContent.Length)

    #Need to add public identifier before enum declaration
    $typedef.Item(0) = "public $($FileContent[0])"

    foreach ($Line in $FileContent) {
        if ($Line -ne $FileContent[0]) {
            #Need to add comma to enum values if current value isnt last
            if (($Line.Contains('=')) -and ($FileContent[$FileContent.IndexOf($Line) + 1].ToString().Contains('='))) {
                $typedef.Item($FileContent.IndexOf($Line)) = $Line + ','
            }
            else {
                $typedef.Item($FileContent.IndexOf($Line)) = $Line
            }
        }
    }
    #This loads the type in global scope so it can be used outside of this script.
    Add-Type -TypeDefinition ($typedef | Out-String)
}

<# CLASSES #>
if (Test-Path "$PSScriptRoot\Classes\Classes.psd1") {
    $ClassLoadOrder = Import-PowerShellDataFile -Path "$PSScriptRoot\Classes\Classes.psd1" -ErrorAction SilentlyContinue
}

foreach ($Class in $ClassLoadOrder.order) {
    $Path = '{0}\Classes\{1}.ps1' -f $PSScriptRoot, $Class
    if (Test-Path $Path) {
        . $Path
    }
}
<# ------- #>

foreach ($Import in @($Public + $Private + $Deprecate)) {
    try {
        . $Import.FullName 
    }
    catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

foreach ($file in $Public) {
    Export-ModuleMember -Function $file.BaseName
}