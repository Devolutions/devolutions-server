function Refresh-DSOAuthToken {
    [CmdletBinding()]
    param (
        [string]$DeviceCode,
        [string]$VerifCompleteURI 
    )
    
    begin {
        Write-Verbose '[Refresh-DSOAuthToken] Beginning...'

        #if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
        #    throw "Session does not seem authenticated, call New-DSSession."
        #}

        [string]$TokenURI = '/api/connect/token'
    }
    
    process {
        $RequestParams = @{
            URI    = "${Global:DSBaseURI}${TokenURI}"
            Method = 'POST'
            Body   = @{
                grant_type    = 'refresh_token'
                client_id     = 'rdm'
                refresh_token = $Global:DSRefreshToken
            }
        }

        $TokenResponse = Invoke-WebRequest @RequestParams -SessionVariable Global:WebSession -SkipHttpErrorCheck

        if ($TokenResponse.StatusCode -ne [System.Net.HttpStatusCode]::OK) {
            throw 'Error while refreshing tokens.'
        }

        Set-Variable DSSessionToken $TokenResponse.access_token -Scope Global
        Set-Variable DSRefreshToken $TokenResponse.refresh_token -Scope Global
        $Global:WebSession.Headers.Add('tokenId', $TokenResponse.access_token)

        return ConvertFrom-Json $TokenResponse.Content
    }
    
    end {
        
    }
}