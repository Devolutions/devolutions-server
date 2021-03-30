function Get-DSUserSecuritySegment {
    <#
    .SYNOPSIS
        Returns a segment containing user profile infos required for creating a new user.
    #>
    [CmdletBinding()]
    param(
        #FIXME [CustomSecurity]$customSecurityEntity,
        [bool]$deleteSQLLogin,
        [bool]$isServerUserTypeAssumed,
        [array]$repositoryEntities, 
        [bool]$canAdd,
        [bool]$canDelete, 
        [bool]$canEdit, 
        [string]$createdByLoggedUsername,
        [string]$createdByUsername, 
        [string]$creationDate,
        [string]$customSecurity,
        [bool]$hasAccessPVM,
        [bool]$hasAccessRDM,
        [bool]$hasAccessWeb,
        [bool]$hasAccessWebLogin,
        [string]$id, 
        [bool]$isAdministrator, 
        [bool]$isEnabled, 
        [bool]$isLockedOut,
        [string]$lastLockoutDate, 
        [string]$loginEmail, 
        [string]$modifiedDate,
        [string]$modifiedLoggedUsername,
        [string]$modifiedUsername,
        [string]$name, 
        [string]$respositories, 
        [string]$securityKey, 
        [string]$UPN,
        [int]$userLicenseType, 
        [int]$userType
        #[Devolutions.RemoteDesktopManager.UserLicenseTypeMode]$userLicenseType, 
        #[Devolutions.RemoteDesktopManager.UserType]$userType
    )
    PROCESS {
        try {
            $securityData = @{
                #FIXME customSecurityEntity    = $null
                deleteSQLLogin          = $deleteSQLLogin
                isServerUserTypeAssumed = $isServerUserTypeAssumed
                repositoryEntities      = @()
                canAdd                  = $canAdd
                canDelete               = $canDelete
                canEdit                 = $canEdit
                createdByLoggedUsername = if ($createdByLoggedUsername) { $createdByLoggedUsername } else { "" }
                createdByUsername       = if ($createdByUsername) { $createcreatedByUsernamedBy } else { "" }
                creationDate            = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffK")
                customSecurity          = if ($customSecurity) { $customSecurity } else { "" }
                hasAccessPVM            = $hasAccessPVM
                hasAccessRDM            = $hasAccessRDM
                hasAccessWeb            = $hasAccessWeb
                hasAccessWebLogin       = $hasAccessWebLogin
                id                      = [guid]::NewGuid()
                isAdministrator         = $isAdministrator
                isEnabled               = $isEnabled
                isLockedOut             = $isLockedOut
                lastLockoutDate         = if ($lastLockoutDate) { $lastLockoutDate } else { "" }
                loginEmail              = if ($loginEmail) { $loginEmail } else { "" }
                modifiedDate            = if ($modifiedDate) { $modifiedDate } else { "" }
                modifiedLoggedUsername  = if ($modifiedLoggedUsername) { $modifiedLoggedUsername } else { "" }
                modifiedUsername        = if ($modifiedUsername) { $modifiedUsername } else { "" }
                name                    = if ($name) { $name } else { "" }
                respositories           = if ($respositories) { $respositories } else { "" }
                securityKey             = if ($securityKey) { $securityKey } else { "" }
                UPN                     = if ($UPN) { $UPN } else { "" }
                userLicenseType         = switch ($userLicenseType) {
                    0 { "Default" }
                    1 { "ConnectionManagement" }
                    2 { "PasswordManagement" }
                    Default { throw "Invalid license type. Please choose a type between 0 and 2 (Inclusivly)." }
                }
                userType                = switch ($userType) {
                    0 { "Admin" }
                    1 { "User" }
                    2 { "Restricted" }
                    3 { "ReadOnly" }
                    Default { throw "Invalid user type. Please choose a type between 0 and 3 (Inclusivly)." }
                }
            }
        
            return ($securityData)
        }
        catch {
            throw  $_.Exception
        }
    }    
}