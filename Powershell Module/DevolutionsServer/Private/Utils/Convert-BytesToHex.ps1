Function Convert-BytesToHex {
<#
.SYNOPSIS
  Converts a byte array to a Hex string
.DESCRIPTION
  Converts a byte array to a Hex string. Used specifically for Devolutions Server
.PARAMETER Bytes
  The byte array to convert in textual representation
.EXAMPLE  
    C:\PS> Convert-BytesToHex -Bytes $aByteArray
#>
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [Byte[]]$Bytes
    )
    $k = [BitConverter]::ToString($Bytes)
    $k = $k.Replace('-', '').ToLowerInvariant()
    return $k
}