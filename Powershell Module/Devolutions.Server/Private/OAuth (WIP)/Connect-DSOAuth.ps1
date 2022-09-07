function Connect-DSOAuth {
    [CmdletBinding()]
    param (
        [string]$Username,
        [string]$Password,
        [string]$DomainId    
    )
    
    begin {
        $InstanceName = $Global:DSBaseURI.Split('/')[-1]
        $ReturnUrl = $Global:DSVerificationUriComplete.Replace($Global:DSBaseURI, '')
        $ReturnUrlClean = $ReturnUrl.Replace('/', '%2F').Replace('=', '%3D').Replace('?', '%3F')
    }
    
    process {
        $ModuleVersion = (Get-Module Devolutions.Server).Version.ToString()

        $Body = @{
            TwoFactorInfo   = $null
            loginParameters = @{
                client         = 'Powershell'
                platform       = 'Web'
                password       = $Password
                safeSessionKey = $Global:DSSafeSessionKey
                version        = $ModuleVersion
            }
            userName        = $Username
        }

        if (![string]::IsNullOrWhiteSpace($DomainId)) {
            $Body.loginParameters.authenticationMethod = 3
            $Body.loginParameters.domainId = $DomainId
        }

        $ConnectRequestParams = @{
            URI    = "${Global:DSBaseURI}/api/login-oauth?csFromXml=1&returnUrl=%2F${InstanceName}${ReturnUrlClean}"
            Method = 'POST'
            Body   = $Body | ConvertTo-Json -Depth 10
        }

        $ConnectResponse = Invoke-WebRequest @ConnectRequestParams -SessionVariable Global:WebSession -ContentType 'application/json' -SkipHttpErrorCheck

        if ($ConnectResponse.StatusCode -ne 200) {
            throw
        }
    }
    
    end {
        $ConnectResponse.StatusCode -eq 200 ? 
        (Write-Verbose '[Connect-DSOAuth] Connected successfully!') : 
        (Write-Verbose '[Connect-DSOAuth] Could not connect to DVLS.')
    }
}