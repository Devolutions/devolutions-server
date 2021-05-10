function PreloadHeaders{
    [cmdletbinding()]
    param(
        [Hashtable]$headers
    )
    $Global:DSHdr = $headers
}    
