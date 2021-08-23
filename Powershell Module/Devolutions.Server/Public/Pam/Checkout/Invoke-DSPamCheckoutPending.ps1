function Invoke-DSPamCheckoutPending {
    <#
        .SYNOPSIS
        Approve or deny a pending checkout request.
        .DESCRIPTION
        Change the state of a pending checkout request depending on the -Accept flag parameter.
        .EXAMPLE
        Please check the sample script provided with the module.
    #>
    [CmdletBinding()]
    PARAM (
        [PamCheckout]$CredentialCheckout,
        [switch]$Accept,
        [string]$ApproverMessage = $null
    )
    
    BEGIN {
        Write-Verbose '[Invoke-DSPamCheckout] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $CredentialCheckout.Status = $Accept ? 4 : 3
        $CredentialCheckout.ApproverMessage = $ApproverMessage

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/pam/checkouts/$($CredentialCheckout.ID)"
            Method = 'PUT'
            Body   = ConvertTo-Json $CredentialCheckout
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Invoke-DSPamCheckout] Completed successfully!') : (Write-Verbose '[Invoke-DSPamCheckout] Ended with errors...')
    }
}