Set-StrictMode -Version 1.0

$ModuleName = $(Get-Item $PSCommandPath).BaseName
$Manifest = Import-PowerShellDataFile -Path $(Join-Path $PSScriptRoot "${ModuleName}.psd1")

Export-ModuleMember -Cmdlet @($manifest.CmdletsToExport)

$Public = @(Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1" -Recurse)
$Private = @(Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1" -Recurse)
$Deprecate = @(Get-ChildItem -Path "$PSScriptRoot/Deprecate/*.ps1" -Recurse)

foreach ($Import in @($Public + $Private + $Deprecate)) {
    try {
        <# Needed to add enums and validators to global scope. Dot sourcing didnt work, we need to "AddType".
        Other solution is .ps1xml (type definitions) but this is easier and doesn't take long #>
        if ($Import.Directory.Name -in @('enums')) {
            $FileContent = Get-Content $Import.FullName
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
        else {
            . $Import.FullName
        }
    }
    catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

foreach ($file in $Public) {
    Export-ModuleMember -Function $file.BaseName
}

<#
foreach ($file in $Enums ) {
    $FileContent = Get-Content $file.FullName | Out-String

    Add-Type -TypeDefinition @"
    public enum AddEntryMode
    {
    Default = 0,
    TemplateListWithBlank = 1,
    TemplateListOnly = 2,
    NoTemplate = 3
    }
"@
}
#>