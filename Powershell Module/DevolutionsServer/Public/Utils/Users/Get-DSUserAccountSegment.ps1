function Get-DSUserAccountSegment {
    <#
    .SYNOPSIS
        Returns a segment containing user profile infos required for creating a new user.
    #>
    [CmdletBinding()]
    param(
        [bool]$hasPrivateVault,
        [bool]$isChangePasswordAllowed,
        [Parameter(Mandatory)]
        [string]$password,
        #TODO What is this? (Coming from py generated models) [UserEntityPasswordFormat]
        #TODO [TwoFactorInfo]
        [string]$connectionOverrides,
        [string]$connectionOverridesCacheID,
        [string]$createdByLoggedUsername,
        [string]$createdByUsername,
        [string]$creationDate,
        [string]$data,
        [string]$email,
        [string]$fullName,
        [string]$id,
        [bool]$isOwner,
        [bool]$isTemplate,
        [string]$lastLoginDate,
        [string]$modifiedDate,
        [string]$modifiedLoggedUsername,
        [string]$modifiedUsername,
        [bool]$resetTwoFactor,
        [string]$securityKey,
        [bool]$userMustChangePasswordAtNextLogin
    )
    PROCESS {
        try {
            $accountData = @{
                hasPrivateVault                   = $hasPrivateVault
                password                          = Protect-ResourceToHexString $password
                connectionOverrides               = if ($connectionOverrides) { $connectionOverrides } else { "" }
                connectionOverridesCacheID        = if ($connectionOverridesCacheID) { $connectionOverridesCacheID } else { "" }
                createdByLoggedUsername           = if ($createdByLoggedUsername) { $createdByLoggedUsername } else { "" }
                createdByUsername                 = if ($createdByUsername) { $createdByUsername } else { "" }
                creationDate                      = if ($creationDate) { $creationDate } else { "" }
                data                              = if ($data) { $data } else { "" }
                email                             = if ($email) { $email } else { "" }
                fullName                          = if ($fullName) { $fullName } else { "" }
                id                                = [guid]::NewGuid()
                isOwner                           = $isOwner
                isTemplate                        = $isTemplate
                lastLoginDate                     = ""
                modifiedDate                      = ""
                modifiedLoggedUsername            = ""
                modifiedUsername                  = ""
                resetTwoFactor                    = $resetTwoFactor
                securityKey                       = if ($securityKey) { $securityKey } else { "" }
                userMustChangePasswordAtNextLogin = $userMustChangePasswordAtNextLogin
            }
        
            return ($accountData)
        }
        catch {
            throw  $_.Exception
        }
    }    
}