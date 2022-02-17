function New-DSSessionOAuth {
    [CmdletBinding()]
    param (
        [string]$BaseURI = $(throw '[New-DSSessionOAuth] You must provide a base URI.')
    )
    
    begin {
        Write-Verbose '[New-DSSessionOAuth] Beginning...'

        #if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
        #    throw "Session does not seem authenticated, call New-DSSession."
        #}

        Set-Variable -Name DSBaseURI -Value $BaseUri -Scope Global
    }
    
    process {
        #1. Fetch config
        $Config = Request-DSOAuthConfiguration

        #2. Fetch device authorization info
        $DeviceAuthInfo = Request-DSOAuthDeviceInfo $Config.device_authorization_endpoint
        
        #3. Prompt user
        Start-Process $DeviceAuthInfo.verification_uri_complete

        #3. Fetch tokens
        Request-DSOAuthAccessToken -DeviceCode $DeviceAuthInfo.device_code -VerifCompleteURI $DeviceAuthInfo.verification_uri_complete
    }
    
    end {
        
    }
}