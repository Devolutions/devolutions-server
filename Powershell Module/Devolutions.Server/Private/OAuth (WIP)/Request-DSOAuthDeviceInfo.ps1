function Request-DSOAuthDeviceInfo {
    [CmdletBinding()]
    param (
        $DeviceAuthURI = $(throw '[Get-DSOAuthDeviceCode] You must provide a base URI.')
    )
    
    begin {
        Write-Verbose '[Get-DSOAuthDeviceInfo] Beginning...'

        #if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
        #    throw "Session does not seem authenticated, call New-DSSession."
        #}
    }
    
    process {
        $RequestParams = @{
            URI    = $DeviceAuthURI
            Method = 'POST'
            Body   = @{
                client_id = 'rdm'
                scope     = 'openid offline_access'
                platform  = 'Windows'
                client    = 'RDM'
            }
        }

        $RequestResponse = Invoke-WebRequest @RequestParams

        if ($RequestResponse.StatusCode -ne [System.Net.HttpStatusCode]::OK) {
            throw 'Error while fetching device authorization info.'
        }

        return ConvertFrom-Json $RequestResponse.Content
    }
    
    end {
        
    }
}