function New-DSSessionOAuth {
    [CmdletBinding()]
    param (
        [pscredential]$Credential = $null,
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

        #2. Fetch device authorization info (device code and verif complete uri set as global vars)
        Request-DSOAuthDeviceInfo $Config.device_authorization_endpoint

        #3. Connection
        Connect-DSOAuth $Credential.UserName $Credential.GetNetworkCredential().Password

        #4. Verify connection
        Test-DSOAuthConnected

        #5. Fetch tokens
        Request-DSOAuthAccessToken
    }
    
    end {
        
    }
}