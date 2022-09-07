function Request-DSOAuthDeviceInfo {
    [CmdletBinding()]
    param (
        $DeviceAuthURI = $(throw '[Get-DSOAuthDeviceCode] You must provide a base URI.')
    )
    
    begin {
        Write-Verbose '[Get-DSOAuthDeviceInfo] Beginning...'
    }
    
    process {
        $RequestParams = @{
            URI    = $DeviceAuthURI
            Method = 'POST'
            Body   = @{
                client_id = 'powershell'
                scope     = 'openid offline_access'
                platform  = 'Windows'
                client    = 'Powershell'
            }
        }

        $RequestResponse = Invoke-WebRequest @RequestParams

        if (($RequestResponse.StatusCode -ne [System.Net.HttpStatusCode]::OK) -or (!(Test-Json $RequestResponse.Content))) {
            throw '[Request-DSOAuthDeviceInfo] Error while fetching device info'
        }

        $JsonContent = ConvertFrom-Json $RequestResponse.Content

        Set-Variable DSDeviceCode $JsonContent.device_code -Scope Global
        Set-Variable DSVerificationUriComplete $JsonContent.verification_uri_complete -Scope Global
    }
    
    end {
        $RequestResponse.StatusCode -eq [System.Net.HttpStatusCode]::OK ? 
        (Write-Verbose '[Request-DSOAuthDeviceInfo] Completed successfully!') : 
        (Write-Verbose '[Request-DSOAuthDeviceInfo] Could not get your device info.')
    }
}