function Get-DSAuthenticationModes {
    [CmdletBinding()]
    param ()
    
    begin {
        Write-Verbose '[Get-DSAuthenticationModes] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            URI = "$Script:DSBaseURI/api/configuration/authentication"
            Method = 'GET'
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Get-DSAuthenticationModes] Completed successfully!') : (Write-Verbose '[Get-DSAuthenticationModes] Ended with errors...')
    }
}