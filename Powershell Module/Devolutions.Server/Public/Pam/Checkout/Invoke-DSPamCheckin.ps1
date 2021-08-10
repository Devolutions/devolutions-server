function Invoke-DSPamCheckin {
    [CmdletBinding()]
    PARAM (
        [Parameter(Mandatory)]
        [PamCheckout]$PamCheckout
    )
    
    BEGIN {
        Write-Verbose '[Invoke-DSPamCheckin] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $PamCheckout.status = [CheckoutStatus]::Ended

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/pam/checkouts/$($PamCheckout.ID)"
            Method = 'PUT'
            Body   = (ConvertTo-Json $PamCheckout)
        }

        try {
            $res = Invoke-DS @RequestParams
            return $res
        }
        catch { throw $_.ErrorDetails }
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Invoke-DSPamCheckin] Completed successfully!') : (Write-Verbose '[Invoke-DSPamCheckin] Ended with errors...')
    }
}