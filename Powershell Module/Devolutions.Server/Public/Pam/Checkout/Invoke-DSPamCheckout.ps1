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

        [PamCheckout]$CredentialCheckout = ($res = Invoke-DS @RequestParams).isSuccess ? ($res.Body) : $(Write-Error 'Please validate that the approver ID correspond to an existing user.')

        if ($CredentialCheckout.Status -eq 4) {
            Write-Verbose '[Invoke-DSPamCheckout] The checkout is already completed since this credential does not require an approval.'

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