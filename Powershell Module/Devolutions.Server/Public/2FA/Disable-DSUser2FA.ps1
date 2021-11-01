function Disable-DSUser2FA {
    [CmdletBinding()]
    param (
        [guid]$UserID
    )
    
    begin {
        Write-Verbose '[Disable-DSUser2FA] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            Uri    = "$Script:DSBaseUri/api/security/twofactor/reset"
            Method = 'Post'
            Body   = (ConvertTo-Json @{
                    resetTwoFactor = $true
                    userId         = $UserID
                })
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Disable-DSUser2FA] Completed successfully!') : (Write-Verbose '[Disable-DSUser2FA] Ended with errors...')
    }
}