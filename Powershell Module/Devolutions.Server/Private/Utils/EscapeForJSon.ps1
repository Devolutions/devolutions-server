function EscapeForJSon {
    Param (
        [Parameter(Mandatory)]
        [string]$JSONString
    )

    $JSONString = $JSONString -replace "\\","\\" -replace '"','\"'

    return $JSONString
}