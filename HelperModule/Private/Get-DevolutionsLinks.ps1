function Get-DevolutionsLinks {
    param (
        [Parameter(Mandatory)][string]$Pattern
    )
    $htm = (Invoke-WebRequest https://devolutions.net/products.htm -UseBasicParsing).Content
    $htmParsed = $htm -split "`n"
    $cdnUrl = $htmParsed | Select-String -Pattern $Pattern
    $cdnUrl.Line.SubString($cdnUrl.Line.IndexOf('=') + 1)
}

<# Possible Patterns for our use

RDMEnterprise.Version
RDMBeta.Version
RDM Enterprise = RDMEnterprise.Exe

RDMFree.Version
RDM Free = RDMFree.Exe

DPS.Version
DVLS Console GA = DPSConsole.Exe
DVLS ZIP GA = DPS.Url

DPSLts.Version
DVLS Console LTS = DPSConsoleLts.Exe
DVLS ZIP LTS = DPSLts.Url
#>
