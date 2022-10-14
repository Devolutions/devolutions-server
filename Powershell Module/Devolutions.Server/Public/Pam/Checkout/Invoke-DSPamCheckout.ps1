function Invoke-DSPamCheckout {
    <#
        .SYNOPSIS
        Creates a checkout request.
        .DESCRIPTION
        Creates a checkout request for the provided PAM credential. Also decrypt and return the password
        if approval is not required or if approved ID is the same as the asking user's ID.
        .EXAMPLE
        Please check the sample script provided with the module.
    #>
    [CmdletBinding()]
    PARAM (
        [guid]$PamCredentialID = $(throw 'You must provide a valid ID.'),
        [string]$Reason,
        [guid]$ApproverID
    )
    
    BEGIN {
        Write-Verbose '[Invoke-DSPamCheckout] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        #1. Fetch PAM cred (api/pam/credentials/$id) 
        $PamCredential = ($res = Get-DSPamCredential $PamCredentialID).isSuccess ? ($res.Body) : $(throw 'Failed while fetching credentials. Please make sure the ID you provided is a valid PAM account ID and try again.')

        #2. Checkout
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/pam/checkouts"
            Method = 'POST'
            Body   = @{credentialID = $PamCredentialID; duration = 240 }
        }

        if ($PamCredential.checkoutApprovalMode -eq 2) {
            $RequestParams.Body += @{approverID = $ApproverID }
        }

        if ($PamCredential.checkoutReasonMode -in @(2, 3)) {
            $RequestParams.Body += @{reason = $Reason }
        }
    
        $RequestParams.Body = ConvertTo-Json $RequestParams.Body

        try {
            $CheckoutRes = Invoke-DS @RequestParams
            if (!$CheckoutRes.isSuccess) {
                throw $CheckoutRes.ErrorMessage
            }
        }
        catch {
            if ($_.Exception.Message -eq 'The credential is already checked out.') {
                Write-Error "The credential '$($PamCredential.label)' is already checked out."
            } else {
                Write-Error $_.Exception.Message
            }
            Return
        }

        if ($CheckoutRes.Body.Status -eq 4) {
            Write-Verbose '[Invoke-DSPamCheckout] The checkout is already completed since this credential does not require an approval.'

            #3. Get Password
            $Password = ($res = Get-DSPamPassword $PamCredentialID).isSuccess ? ($res.Body) : ($res.ErrorMessage ? $(throw $res.ErrorMessage): $(throw 'Failed while fetching password. See logs for information.'))

            #4. Return checkout info and decrypted password
            $CheckoutRes.Body = @{CheckoutInfo = [pscustomobject]$CheckoutRes.Body; Password = $Password.data}
        }
        
        return $CheckoutRes
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Invoke-DSPamCheckout] Completed successfully!') : (Write-Verbose '[Invoke-DSPamCheckout] Ended with errors...')
    }
}