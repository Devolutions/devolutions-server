function Get-DevolutionsLinks {
    param (
        [Parameter(Mandatory)][string]$Pattern
    )
    $htm = (Invoke-WebRequest https://devolutions.net/products.htm -UseBasicParsing).Content
    $htmParsed = $htm -split "`n"
    $cdnUrl = $htmParsed | Select-String -Pattern $Pattern
    $cdnUrl.Line.SubString($cdnUrl.Line.IndexOf('=') + 1)
}