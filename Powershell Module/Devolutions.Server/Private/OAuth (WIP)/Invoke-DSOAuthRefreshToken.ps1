function Invoke-DSOAuthRefreshToken {
    [CmdletBinding()]
    param ()
    
    begin {
        Write-Verbose '[Refresh-DSOAuthToken] Beginning...'

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

        if (($TokenResponse.StatusCode -ne [System.Net.HttpStatusCode]::OK) -or !(Test-Json $TokenResponse.Content)) {
            throw 'Error while refreshing tokens.'
        }

        $jsonContent = ConvertFrom-Json $TokenResponse.Content

        Set-Variable DSSessionToken $jsonContent.access_token -Scope Global -Force
        Set-Variable DSRefreshToken $jsonContent.refresh_token -Scope Global -Force
        $Global:WebSession.Headers.Add('Authorization', "bearer $($jsonContent.access_token)")

        return $jsonContent
    }
    
    end {
        $TokenResponse.StatusCode -eq [System.Net.HttpStatusCode]::OK ? 
        (Write-Verbose '[Refresh-DSOAuthToken] Token refreshed successfully!') : 
        (Write-Verbose '[Refresh-DSOAuthToken] Could not refresh your authentication token.')
    }
}