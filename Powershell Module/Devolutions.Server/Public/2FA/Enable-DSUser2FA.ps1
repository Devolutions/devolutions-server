function Enable-DSUser2FA {
    [CmdletBinding()]
    param (
        [guid]$UserId
        #[?] 2fa method
    )
    
    begin {
        Write-Verbose '[Enable-DSUser2FA] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        # 1. Check if user exists
        $UserInfo = ($res = Get-DSUsers -candidUserId $UserId).isSuccess ? $res.Body.data : $(throw 'User could not be found.')
        
        # 2. Check if authenticator 2fa enabled on server
        $RequestParams = @{
            Uri    = "$Script:DSBaseURI/api/configuration/two-factor"
            Method = 'Get'
        }

        $2FAConfig = ($res = Invoke-DS @RequestParams).isSuccess ? $res.Body.data : $(throw 'Fail')

        # 3. Check if authenticator 2fa is avaiable (Only one supported at the moment)
        if ($2FAConfig.twoFactorAuthenticationAvailable -notcontains '1') {
            throw 'Can only enable authenticator type 2FA for the moment.'
        }

        $2FAUserInfo = @{
            accountName        = $UserInfo.userSecurity.name
            authenticationType = 1
            isPreConfigured    = $true;
        } | ConvertTo-Json

        $Safe2FAInfo = Protect-ResourceToHexString ($2FAUserInfo.ToString())

        # 4. Save 2FA user info
        $RequestParams = @{
            Uri    = "$Script:DSBaseURI/api/security/twofactor/save"
            Method = 'Put'
            Body   = (ConvertTo-Json @{
                    SafeTwoFactorInfoString = $Safe2FAInfo
                    UserSecurityEntityID    = $UserInfo.userSecurity.id
                })
        }

        $res = Invoke-DS @RequestParams
        return $res
    }

    end {
        $res.isSuccess ? (Write-Verbose '[Enable-DSUser2FA] Completed successfully!') : (Write-Verbose '[Enable-DSUser2FA] Ended with errors...')
    }
}