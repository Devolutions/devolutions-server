function Get-DSUserSecuritySegment {
    <#
    .SYNOPSIS
        Returns a segment containing user profile infos required for creating a new user.
    #>
    [CmdletBinding()]
    param(
        [string]$name,
        [int]$userType,
        [bool]$isAdministrator,
        [bool]$isEnabled,
        [bool]$isLockedOut,
        #[string]$departments,
        #[string]$securityKey,
        #[string]$accountSettings,
        [bool]$canAdd,
        [bool]$canDelete,
        [bool]$canEdit,
        [string]$customSecurity,
        [bool]$canAddCredentials,
        [bool]$canAddDataEntry,
        [bool]$canEditCredentials,
        [bool]$canEditDataEntry,
        [bool]$canDeleteCredentials,
        [bool]$canDeleteDataEntry,
        #[int]$failedPasswordAttemptCount,
        [string]$UPN, #?
        [int]$authenticationType,
        [string]$loginEmail,
        [bool]$hasAccessRDM,
        #[bool]$hasAccessPVM,
        [bool]$hasAccessWeb,
        [bool]$hasAccessWebLogin,
        [int]$userLicenseTypeMode,
        [bool]$hasAccessLauncher,
        [bool]$hasAccessCli
        #[string]$assigned
        #[string]$identityProviderId

    )
    BEGIN {
    }
    PROCESS {
        try {
            $securityData = @{
                Name                 = if ($name) { $name } else { "" }
                #departments                = if ($departments) { $departments } else { "" }
                #securityKey                = if ($securityKey) { $securityKey } else { "" }
                #accountSettings            = if ($accountSettings) { $accountSettings } else { "" }  
                customSecurity       = if ($customSecurity) { $customSecurity } else { "" }
                #failedPasswordAttemptCount = if ($failedPasswordAttemptCount++ -gt 3) {  } else { $failedPasswordAttemptCount++ } #Probably not needed, else probably needs a check of some sort
                UPN                  = if ($UPN) { $UPN } else { "" }
                loginEmail           = if ($loginEmail) { $loginEmail } else { "" }
                #assigned                   = if ($assigned) { $assigned } else { "" }
                #identityProviderId         = if ($identityProviderId) { $identityProviderId } else { "" }
                isAdministrator      = $false #$isAdministrator
                isEnabled            = $true #$isEnabled
                isLockedOut          = $false #$isLockedOut
                canAdd               = $true #$canAdd
                canDelete            = $true #$canDelete
                canEdit              = $true #$canEdit
                canAddCredentials    = $true #$canAddCredentials
                canAddDataEntry      = $true #$canAddDataEntry
                canEditCredentials   = $true #$canEditCredentials
                canEditDataEntry     = $true #$canEditDataEntry
                canDeleteCredentials = $true #$canDeleteCredentials
                canDeleteDataEntry   = $true #$canDeleteDataEntry
                hasAccessRDM         = $hasAccessRDM
                #hasAccessPVM               = $hasAccessPVM
                hasAccessWeb         = $hasAccessWeb
                hasAccessWebLogin    = $hasAccessWebLogin
                hasAccessLauncher    = $hasAccessLauncher
                hasAccessCli         = $true #$hasAccessCli

                userType             = switch ($userType) {
                    0 { [Devolutions.RemoteDesktopManager.UserType]::Admin }
                    1 { [Devolutions.RemoteDesktopManager.UserType]::User }
                    2 { [Devolutions.RemoteDesktopManager.UserType]::Restricted }
                    3 { [Devolutions.RemoteDesktopManager.UserType]::ReadOnly }
                    Default { throw "Invalid user type. Value must be between 0 and 3." }
                }
                userLicenseTypeMode  = switch ($userLicenseTypeMode) {
                    0 { [Devolutions.RemoteDesktopManager.UserLicenceTypeMode]::Default }
                    1 { [Devolutions.RemoteDesktopManager.UserLicenceTypeMode]::ConnectionManagement }
                    2 { [Devolutions.RemoteDesktopManager.UserLicenceTypeMode]::PasswordManagement }
                    Default { throw "Invalid user license type mode. Value must be between 0 and 2 inclusivly." }
                }
                authenticationType   = switch ($authenticationType) {
                    0 { [Devolutions.RemoteDesktopManager.ServerUserType]::Builtin }
                    3 { [Devolutions.RemoteDesktopManager.ServerUserType]::Domain }
                    5 { [Devolutions.RemoteDesktopManager.ServerUserType]::None }
                    8 { [Devolutions.RemoteDesktopManager.ServerUserType]::Office365 }
                    9 { [Devolutions.RemoteDesktopManager.ServerUserType]::Application }
                    Default { throw "Unsupported authentication type. Please select a" }
                }
            }

            return ($securityData)
        }
        catch {
            throw  $_.Exception
        }
    }    
}