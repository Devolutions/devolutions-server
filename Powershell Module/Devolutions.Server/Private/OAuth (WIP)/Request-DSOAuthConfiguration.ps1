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
        
        if ($ConfigResponse.StatusCode -ne [System.Net.HttpStatusCode]::OK) {
            throw 'Error while fetching OpenID configuration'
        }

        return ConvertFrom-Json $ConfigResponse.Content
    }
    
    end {
        $ConfigResponse.StatusCode -eq [System.Net.HttpStatusCode]::OK ?
        (Write-Verbose '[Request-DSOAuthConfiguration] Completed successfully.') :
        (Write-Verbose '[v] Ended with errors...')
    }
}