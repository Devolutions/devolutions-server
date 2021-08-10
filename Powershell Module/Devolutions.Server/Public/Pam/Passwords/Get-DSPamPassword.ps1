function Get-DSPamPassword {
    [CmdletBinding()]
    PARAM (
        [guid]$PamCredentialID
    )
    
    BEGIN {
        Write-Verbose '[Get-DSPamPassword] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/pam/passwords/$PamCredentialID"
            Method = 'GET'
        }

        try {
            $res = Invoke-DS @RequestParams
            return $res
        }
        catch { throw $_.ErrorDetails }
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Get-DSPamPassword] Completed successfully!') : (Write-Verbose '[Get-DSPamPassword] Ended with errors...')
    }
}