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
                Method = ($Global:DSInstanceVersion -ge ([version]'2021.2.14.0')) ? 'POST' : 'GET'
            }

            $res = Invoke-DS @RequestParams

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