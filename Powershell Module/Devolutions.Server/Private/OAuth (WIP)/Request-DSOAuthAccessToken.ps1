function Request-DSOAuthAccessToken {
    [CmdletBinding()]
    param (
        [string]$DeviceCode,
        [string]$VerifCompleteURI 
    )
    
    begin {
        Write-Verbose '[Request-DSOAuthAccessToken] Beginning...'

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
                grant_type  = 'urn:ietf:params:oauth:grant-type:device_code'
                client_id   = 'rdm'
                device_code = $DeviceCode
            }
        }

        $TokenResponse = Invoke-WebRequest @RequestParams -SessionVariable Global:WebSession -SkipHttpErrorCheck

        while (!$TokenResponse -or ($TokenResponse.StatusCode -ne [System.Net.HttpStatusCode]::OK)) {
            Start-Sleep 3
            $TokenResponse = Invoke-WebRequest @RequestParams -SkipHttpErrorCheck

            $OAuthWindow = Get-Process 'chrome' | Where-Object { $_.MainWindowTitle -like 'Devolutions Server*' } -ErrorAction SilentlyContinue

            #User closed window without logging in
            if ($null -eq $OAuthWindow -and $TokenResponse.StatusCode -ne [System.Net.HttpStatusCode]::OK) {
                Start-Process $VerifCompleteURI
            }
        }

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
        
    }
}