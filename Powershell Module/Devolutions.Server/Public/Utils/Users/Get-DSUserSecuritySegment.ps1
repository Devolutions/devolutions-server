function Get-DSUserSecuritySegment {
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
            $securityData = @{
                Assigned                = $null
                AuthenticationType      = [Devolutions.RemoteDesktopManager.ServerUserType]::($ParamList.AuthenticationType).value__
                CanAdd                  = $true
                CanDelete               = $true
                CanEdit                 = $true
                CreatedByLoggedUsername = ""
                CreatedByUserName       = ""
                CreationDate            = ""
                CustomSecurity          = ""
                CustomSecurityEntity    = @{
                    AllowDragAndDrop    = $ParamList.AllowDragAndDrop
                    CanViewInformations = $ParamList.CanViewInformations
                    CanViewGlobalLogs   = $ParamList.CanViewGlobalLogs
                    CanImport           = $ParamList.CanImport
                    CanExport           = $ParamList.CanExport
                    OfflineMode         = [Devolutions.RemoteDesktopManager.OfflineMode]::($ParamList.OfflineMode)

                }
                DeleteSQLLogin          = [Devolutions.RemoteDesktopManager.DefaultBoolean]::Default
                HasAccessCli            = $ParamList.HasAccessCLI
                HasAccessLauncher       = $ParamList.HasAccessLauncher
                HasAccessRDM            = $ParamList.HasAccessRDM
                HasAccessWeb            = $ParamList.HasAccessWeb
                HasAccessWebLogin       = $ParamList.HasAccessWebLogin
                #ID
                IsAdministrator         = if ($ParamList.UserType -eq [Devolutions.RemoteDesktopManager.UserType]::Admin) { $true } else { $false }
                IsEnabled               = $ParamList.Enabled
                IsLockedOut             = $false
                IsServerUserTypeAssumed = $false
                LastLockoutDate         = $null
                ModifiedDate            = ""
                ModifiedLoggedUserName  = ""
                ModifiedUserName        = ""
                Name                    = $ParamList.Username
                #Repositories            = ""
                #RepositoryEntities      = ""
                #RepositoryNames         = "Default"
                RoleNames               = ""
                SecurityKey             = ""
                ServerUserType          = [Devolutions.RemoteDesktopManager.ServerUserType]::($ParamList.AuthenticationType)
                ServerUserTypeString    = [Devolutions.RemoteDesktopManager.ServerUserType]::($ParamList.AuthenticationType).ToString()
                UPN                     = ""
                UserLicenseType         = [Devolutions.RemoteDesktopManager.UserLicenceTypeMode]::($ParamList.UserLicenseType)
                UserType                = 0 #[Devolutions.RemoteDesktopManager.UserType]::($ParamList.UserType)
                UserTypeString          = ""
            }

            return $securityData
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }    
}