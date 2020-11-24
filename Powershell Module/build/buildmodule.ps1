$buildVersion = $env:BUILDVER
$moduleName = 'DevolutionsServer'

$manifestPath = Join-Path -Path $env:SYSTEM_DEFAULTWORKINGDIRECTORY -ChildPath "$moduleName.psd1"

## Find all of the public functions
$publicFuncFolderPath = Join-Path -Path $PSScriptRoot -ChildPath 'public'
if ((Test-Path -Path $publicFuncFolderPath) -and ($publicFunctionNames = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1' | Select-Object -ExpandProperty BaseName)) {
    $funcStrings = "'$($publicFunctionNames -join "','")'"
} else {
    $funcStrings = $null
}

$Parms = @{
    Path = $manifestPath
    ModuleVersion = $buildVersion
    FunctionsToExport = $funcStrings
}
  
Update-ModuleManifest @Parms