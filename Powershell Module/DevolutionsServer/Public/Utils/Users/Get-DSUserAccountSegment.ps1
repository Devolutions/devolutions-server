function Get-DSUserAccountSegment {
    <#
    .SYNOPSIS
        Returns a segment containing user profile infos required for creating a new user.
    #>
    [CmdletBinding()]
    param(
        [bool]$isChangePasswordAllowed,
        [Parameter(Mandatory)]
        [string]$password,
        [string]$email,
        [string]$fullName,
        [bool]$userMustChangePasswordAtNextLogin
    )
    PROCESS {
        try {
            $accountData = @{
                hasPrivateVault                   = $false
                hasSpecificSettings               = $false
                isChangePasswordAllowed           = $isChangePasswordAllowed
                password                          = $password
                passwordFormat                    = 1
                twoFactorInfo                     = $null
                connectionOverrides               = ""
                connectionOverridesCacheID        = ""
                createdByLoggedUsername           = ""
                createdByUsername                 = ""
                data                              = ""
                email                             = $email
                fullName                          = $fullName
                isOwner                           = $false
                isTemplate                        = $false
                lastLoginDate                     = $null
                modifiedDate                      = $null
                modifiedLoggedUsername            = ""
                modifiedUsername                  = ""
                resetTwoFactor                    = $false
                securityKey                       = ""
                userMustChangePasswordAtNextLogin = $userMustChangePasswordAtNextLogin
            }
        
            return ($accountData)
        }
        catch {
            throw  $_.Exception
        }
    }    
}