function Test-DSOAuthConnected {
    [CmdletBinding()]
    param ()
    
    begin {
        Write-Verbose '[Test-DSOAuthConnected] Beginning...'
    }
    
    process {
        $VerifyParams = @{
            Method             = 'GET' 
            Uri                = $Global:DSVerificationUriComplete
            MaximumRedirection = 0
        }

        $VerifyResponse = Invoke-WebRequest @VerifyParams -WebSession $Global:WebSession -UseBasicParsing -SkipHttpErrorCheck -ErrorAction SilentlyContinue

        if (($Global:WebSession.Cookies.Count -gt 0) -and
            ($VerifyResponse.StatusCode -ne 302 -or !$VerifyResponse.Headers.Location[0] -like '*login-success')) {
            throw
        }

        return $VerifyResponse
    }
    
    end {
        $RequestResponse.StatusCode -eq [System.Net.HttpStatusCode]::OK ? 
        (Write-Verbose '[Request-DSOAuthDeviceInfo] Connection is successful!') : 
        (Write-Verbose '[Request-DSOAuthDeviceInfo] Error while connecting to DVLS...')
    }
}