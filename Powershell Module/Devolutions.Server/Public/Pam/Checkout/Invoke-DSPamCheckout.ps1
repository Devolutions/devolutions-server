function Invoke-DSPamCheckout {
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
    
        #1.1 Check for approver
        if (($PamCredential.checkoutApprovalMode -eq 2) -and !$ApproverID) {
            Write-Error 'This entry requires an approver to check out. Please provide an approver ID and try again.'
        }

        #1.2 Check for reason mode
        if (($PamCredential.checkoutReasonMode -eq 2) -and !$Reason) {
            Write-Error 'This entry requires a reason to check out. Please provide a reason and try again.'
        }

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

        [PamCheckout]$CredentialCheckout = ($res = Invoke-DS @RequestParams).isSuccess ? ($res.Body) : ($res.ErrorMessage ? $(throw $res.ErrorMessage) : $(throw 'Failed while trying to checkout the account. See logs for information.'))

        if ($CredentialCheckout.Status -ne 1) {
            #3. Get Password
            $EncryptedPassword = ($res = Get-DSPamPassword $PamCredentialID).isSuccess ? ($res.Body) : ($res.ErrorMessage ? $(throw $res.ErrorMessage): $(throw 'Failed while fetching password. See logs for information.'))

            #4. Decrypt password
            $DecryptedPassword = Decrypt-String $Global:DSSessionKey $EncryptedPassword

            #5. Return checkout info and decrypted password
            return @{CheckoutInfo = $CredentialCheckout; Password = $DecryptedPassword }
        }
        
        return $CredentialCheckout
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Invoke-DSPamCheckout] Completed successfully!') : (Write-Verbose '[Invoke-DSPamCheckout] Ended with errors...')
    }
}