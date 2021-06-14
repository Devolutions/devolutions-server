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
                AuthenticationType      = [ServerUserType]::($ParamList.AuthenticationType).value__
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
                    OfflineMode         = [OfflineMode]::($ParamList.OfflineMode)

                }
                DeleteSQLLogin          = [DefaultBoolean]::Default
                HasAccessCli            = $ParamList.HasAccessCLI
                HasAccessLauncher       = $ParamList.HasAccessLauncher
                HasAccessRDM            = $ParamList.HasAccessRDM
                HasAccessWeb            = $ParamList.HasAccessWeb
                HasAccessWebLogin       = $ParamList.HasAccessWebLogin
                #ID
                IsAdministrator         = if ($ParamList.UserType -eq [UserType]::Admin) { $true } else { $false }
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
                ServerUserType          = [ServerUserType]::($ParamList.AuthenticationType)
                ServerUserTypeString    = [ServerUserType]::($ParamList.AuthenticationType).ToString()
                UPN                     = ""
                UserLicenseType         = [UserLicenceTypeMode]::($ParamList.UserLicenseType)
                UserType                = 0 #[UserType]::($ParamList.UserType)
                UserTypeString          = ""
            }

            return $securityData
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }    
}