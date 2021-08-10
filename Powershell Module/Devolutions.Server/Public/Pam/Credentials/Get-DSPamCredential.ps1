function Get-DSPamCredential {
    [CmdletBinding()]
    PARAM (
        [guid]$PamCredentialID
    )
    
    BEGIN {
        Write-Verbose '[Get-DSPamCredential] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/pam/credentials/$PamCredentialID"
            Method = 'GET'
        }

        try { 
            $res = Invoke-DS @RequestParams
            return $res
        }
        catch { throw $_.ErrorDetails }
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Get-DSPamCredential] Completed successfully!') : (Write-Verbose '[Get-DSPamCredential] Ended with errors...')
    }
}