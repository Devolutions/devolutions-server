function Get-DSEntryOTP {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [guid]$EntryID
    )
    
    begin {
        Write-Verbose '[Get-DSEntrySensitiveData] Beginning...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        try {        
            $RequestParams = @{
                URI    = "$($Script:DSBaseURI)/api/resolve-otp/$($EntryID)"
                Method = 'POST'
            }

            $res = Invoke-DS @RequestParams
            $res.Body.data.code = Decrypt-String $Global:DSSessionKey $res.Body.data.code

            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    end {
        $res.IsSuccess ? (Write-Verbose '[Get-DSEntryOTPPassword] Completed successfully!') : (Write-Verbose '[Get-DSEntryOTPPassword] Ended with errors...')
    }
}