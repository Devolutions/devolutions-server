function Test-DSOAuthConnected {
    [CmdletBinding()]
    param ()
    
    begin {
        Write-Verbose '[Test-DSOAuthConnected] Beginning...'
    }
    
    process {
        $ReturnUrl = $Global:DSVerificationUriComplete.Replace($Global:DSBaseURI, '')
        $ReturnUrlClean = $ReturnUrl.Replace('/', '%2F').Replace('=', '%3D').Replace('?', '%3F')

        $VerifyParams = @{
            Method          = 'GET' 
            Uri             = $Global:DSVerificationUriComplete
            WebSession      = $Global:WebSession
            MaximumRedirect = 0
        }

        $VerifyResponse = Invoke-WebRequest @VerifyParams -UseBasicParsing -SkipHttpErrorCheck -ErrorAction SilentlyContinue

        if (($Global:WebSession.Cookies.Count -gt 0) -and
            ($VerifyResponse.StatusCode -ne 302 -or !$VerifyResponse.Headers.Location[0] -like '*login-success')) {
            throw
        }

        return $VerifyResponse
    }
    
    end {
        $VerifyResponse.StatusCode -eq [System.Net.HttpStatusCode]::Redirect ? 
        (Write-Verbose '[Test-DSOAuthConnected] Connection is successful!') : 
        (Write-Verbose '[Test-DSOAuthConnected] Error while connecting to DVLS...')
    }
}