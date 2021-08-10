function Get-DSPamCheckout {
    [CmdletBinding()]
    PARAM (
        [guid]$PamCredentialID
    )
    
    BEGIN {
        Write-Verbose '[Get-DSPamCheckout] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/pam/checkouts" 
            Method = 'POST' 
            Body   = (ConvertTo-Json @{ credentialID = $PamCredentialID; duration = 240 })
        }

        try {
            $res = Invoke-DS @RequestParams
            return $res
        }
        catch { throw $_.ErrorDetails }
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Get-DSPamCheckout] Completed successfully!') : (Write-Verbose '[Get-DSPamCheckout] Ended with errors...')
    }
}