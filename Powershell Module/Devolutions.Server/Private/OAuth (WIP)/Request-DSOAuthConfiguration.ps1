function Request-DSOAuthConfiguration {
    [CmdletBinding()]
    param (
    )
    
    begin {
        Write-Verbose '[Request-DSOAuthConfiguration] Beginning...'

        [string]$ConfigURI = '/.well-known/openid-configuration'
    }

    process {
        $RequestParams = @{
            URI    = "${Global:DSBaseURI}${ConfigURI}"
            Method = 'GET'
        }
        
        $ConfigResponse = Invoke-WebRequest @RequestParams
        
        if (($ConfigResponse.StatusCode -ne [System.Net.HttpStatusCode]::OK) -or (!(Test-Json $ConfigResponse.Content))) {
            throw '[Request-DSOAuthConfiguration] Error while fetching OpenID configuration'
        }

        $jsonContent = ConvertFrom-Json $ConfigResponse.Content
        
        Set-Variable DSDeviceCode $jsonContent.device_code -Scope Global
        Set-Variable DSVerificationUriComplete $jsonContent.verification_uri_complete -Scope Global

        return ConvertFrom-Json $ConfigResponse.Content
    }
    
    end {
        $ConfigResponse.StatusCode -eq [System.Net.HttpStatusCode]::OK ?
        (Write-Verbose '[Request-DSOAuthConfiguration] Completed successfully.') :
        (Write-Verbose '[v] Ended with errors...')
    }
}