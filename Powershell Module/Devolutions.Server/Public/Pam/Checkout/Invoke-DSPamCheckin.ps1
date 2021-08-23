function Invoke-DSPamCheckin {
    <#
        .SYNOPSIS
        Check in a currently checked out PAM credential.
        .DESCRIPTION
        To retreive the checkout, as a [PamCheckout] object, pleasee use Get-DSPamCheckout CMDlet.
        .EXAMPLE
        Please check the sample script provided with the module.
    #>
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