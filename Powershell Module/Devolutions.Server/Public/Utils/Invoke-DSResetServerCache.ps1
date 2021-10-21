function Invoke-DSResetServerCache {
    <#
    .SYNOPSIS
    Invalidate server's cache.
    .EXAMPLE
    > Invoke-DSResetServerCache @([ServerCacheElement]::Connections, [ServerCacheElement]::Domain)
    .EXAMPLE
    > Invoke-DSResetServerCache @([ServerCacheElement]::All)
    #>
    [CmdletBinding()]
    param(
        [ServerCacheElement[]]$ElementsToInvalidate
    )

    BEGIN {
        Write-Verbose '[Invoke-DSResetServerCache] Beginning...'
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }
    }

    PROCESS { 
        $Body = @{
            elementToInvalidate = 0
        }

        $ElementsToInvalidate | ForEach-Object {
            $Body.elementToInvalidate += [ServerCacheElement]$_.value__
        }

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/cache/invalidate-element"
            Method = 'POST'
            Body   = (ConvertTo-Json $Body)
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Invoke-DSResetServerCache]') : (Write-Verbose '[Invoke-DSResetServerCache]')
    }
}