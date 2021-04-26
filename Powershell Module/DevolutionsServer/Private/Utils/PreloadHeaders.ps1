function PreloadHeaders{
    [cmdletbinding()]
    param(
        [Hashtable]$headers
    )
    $Script:DSHdr = $headers
}    
