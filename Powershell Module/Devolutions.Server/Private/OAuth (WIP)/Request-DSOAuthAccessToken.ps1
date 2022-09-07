function Request-DSOAuthAccessToken {
    [CmdletBinding()]
    param ()
    
    begin {
        Write-Verbose '[Request-DSOAuthAccessToken] Beginning...'

        [string]$TokenURI = '/api/connect/token'
    }
    
    process {
        $RequestParams = @{
            URI    = "${Global:DSBaseURI}${TokenURI}"
            Method = 'POST'
            Body   = @{
                grant_type  = 'urn:ietf:params:oauth:grant-type:device_code'
                client_id   = 'powershell'
                device_code = $Global:DSDeviceCode
            }
        }

        $TokenResponse = Invoke-WebRequest @RequestParams -SessionVariable Global:WebSession -SkipHttpErrorCheck

        if ($TokenResponse.StatusCode -ne [System.Net.HttpStatusCode]::OK) {
            throw 'Error while retreiving tokens.'
        }

        $JsonTokenResponse = ConvertFrom-Json $TokenResponse.Content

        Set-Variable DSSessionToken $JsonTokenResponse.access_token -Scope Global
        Set-Variable DSRefreshToken $JsonTokenResponse.refresh_token -Scope Global
        Set-Variable -Name DSBaseURI -Value $BaseUri -Scope Script

        $Global:WebSession.Headers.Add('Authorization', "bearer $($JsonTokenResponse.access_token)")

        return $JsonTokenResponse
    }
    
    end {
        $TokenResponse.StatusCode -eq [System.Net.HttpStatusCode]::OK ? 
        (Write-Verbose '[Request-DSOAuthAccessToken] Completed successfully!') : 
        (Write-Verbose '[Request-DSOAuthAccessToken] Could not get your access token.')
    }
}