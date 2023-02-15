function Get-DSUserAccountSegment {
    <#
        .SYNOPSIS
        Returns a segment containing user profile infos required for creating a new user.
    #>
    [CmdletBinding()]
    PARAM(
        [PSCustomObject]$ParamList
    )
    PROCESS {
        try {
            $AccountSegment = @{
                hasPrivateVault                   = $false
                hasSpecificSettings               = $false
                isChangePasswordAllowed           = $false
                password                          = $ParamList.Password
                passwordFormat                    = 1
                twoFactorInfo                     = $null
                connectionOverrides               = ""
                connectionOverridesCacheID        = ""
                createdByLoggedUsername           = ""
                createdByUsername                 = ""
                creationDate                      = ""
                data                              = ""
                email                             = $ParamList.Email
                fullName                          = ""
                id                                = $null
                isOwner                           = $false
                isTemplate                        = $false
                lastLoginDate                     = $null
                modifiedDate                      = $null
                modifiedLoggedUsername            = ""
                modifiedUsername                  = ""
                resetTwoFactor                    = $false
                securityKey                       = ""
                userMustChangePasswordAtNextLogin = $ParamList.UserMustChangePasswordAtNextLogin
            }
        
            return $AccountSegment
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }    
}