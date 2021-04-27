function Update-DSUser {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$UserID,

        #General tab
        [Devolutions.RemoteDesktopManager.UserType]$UserType = [Devolutions.RemoteDesktopManager.UserType]::User, #TODO Maybe not needed
        [Devolutions.RemoteDesktopManager.UserLicenceTypeMode]$UserLicenseType = [Devolutions.RemoteDesktopManager.UserLicenceTypeMode]::Default,

        [ValidateNotNullOrEmpty()]
        [string]$Username,
        
        [string]$Password,
        [string]$FirstName = "",
        [string]$LastName = "",
        [string]$Email = "",
        [ValidateSet("English", "French", "German", "Spanish", "Hungarian", "Italian", "Dutch", "Polish (Poland)", "Russian", "Swedish", "Ukrainian", "Chinese (Simplified) Legacy", "Chinese (Traditional, Taiwan)", "Czech")]
        [string]$Language = "English",
        [bool]$Enabled = $true,
        [bool]$UserMustChangePasswordAtNextLogin = $false,

        #Information tab
        [string]$CompanyName = "",
        [string]$JobTitle = "",
        [string]$Department = "",
        [string]$GravatarEmail = "",
        [string]$Address = "",
        [string]$State = "",
        [string]$CountryName = "", #TODO Find a way to validateset country name
        [string]$Phone = "",
        [string]$Workphone = "",
        [string]$CellPhone = "",
        [string]$Fax = "",

        #Application access tab
        [bool]$HasAccessRDM = $true,
        [bool]$HasAccessWebLogin = $true,
        [bool]$HasAccessLauncher = $true,
        [bool]$HasAccessWeb = $true,
        [bool]$HasAccessCLI = $true,

        #Privileges tab
        [bool]$AllowDragAndDrop = $true, #CustomSecurityEntity
        [bool]$CanViewInformations = $true, #CustomSecurityEntity
        [bool]$CanViewGlobalLogs = $true, #CustomSecurityEntity
        [bool]$CanImport = $true, #CustomSecurityEntity
        [bool]$CanExport = $true, #CustomSecurityEntity

        [ValidateSet([Devolutions.RemoteDesktopManager.OfflineMode]::Disabled, [Devolutions.RemoteDesktopManager.OfflineMode]::ReadOnly, [Devolutions.RemoteDesktopManager.OfflineMode]::ReadWrite)]
        [string]$OfflineMode = [Devolutions.RemoteDesktopManager.OfflineMode]::ReadWrite #CustomSecurityEntity
    )
    
    BEGIN {
        Write-Verbose "[Update-DSUser] Begining..."

        $URI = "$env:DS_URL/api/security/user/save?csToXml=1"

        $UserProfileParams = @('CompanyName', 'JobTitle', 'Department', 'GravatarEmail', 'Address', 'State', 'Country', 'Phone', 'Workphone', 'CellPhone', 'Fax', 'FirstName', 'LastName')
        $UserAccountParams = @('Password', 'UserMustChangePasswordAtNextLogin', 'Email')
        $UserSecurityParams = @('UserType', 'HasAccessRDM', 'HasAccessWebLogin', 'HasAccessLauncher', 'HasAccessWeb', 'HasAccessCLI')
        $CustomSecurityParams = @('AllowDragAndDrop', 'CanViewInformations', 'CanViewGlobalLogs', 'CanImport', 'CanExport', 'OfflineMode')

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $PSBoundParameters

            $User = if (($response = Get-DSUsers -candidUserId $UserID).isSuccess) {
                $response.Body.data
            }
            else {
                throw [System.Management.Automation.ItemNotFoundException]::new("User could not be found. Make sure you are using a valid ID and try again.")
            }

            $PSBoundParameters.GetEnumerator() | ForEach-Object {
                if ($_.Key -notin @("UserID", "Verbose")) {
                    #Key is in UserAccount segment
                    if ($_.Key -in $UserAccountParams) {
                        if ($_.Key -in $User.userAccount.PSObject.Properties.Name) { 
                            $User.userAccount.($_.Key) = $_.Value 
                        }
                        else {
                            $User.userAccount | Add-Member -NotePropertyName $_.Key -NotePropertyValue $_.Value 
                        }   
                    }

                    #Key is in UserProfile segment
                    if ($_.Key -in $UserProfileParams) {
                        if ($_.Key -in $User.userProfile.PSObject.Properties.Name) { 
                            $User.userProfile.($_.Key) = $_.Value 
                        }
                        else {
                            $User.userProfile | Add-Member -NotePropertyName $_.Key -NotePropertyValue $_.Value 
                        }                        
                    }

                    #Key is in UserSecurity segment or in UserSecurity.CustomSecurityEntity
                    if (($_.Key -in $UserSecurityParams) -or ($_.Key -in $CustomSecurityParams)) {
                        #Key is in CustomSecurityEntity
                        if ($_.Key -in $CustomSecurityParams) {
                            $tempName = switch ($_.Key) {
                                'AllowDragAndDrop' { "allowDragAndDrop" }
                                'CanViewInformations' { "canViewInformations" }
                                'CanViewGlobalLogs' { "canViewGlobalLogs" }
                                'CanImport' { "canImport" }
                                'CanExport' { "canExport" }
                                'OfflineMode' { "offlineMode" }
                            }

                            if ($tempName -in $User.userSecurity.customSecurityEntity.PSObject.Properties.Name) {
                                $User.userSecurity.customSecurityEntity.($_.Key) = $_.Value
                            }
                            else {
                                $User.userSecurity.customSecurityEntity | Add-Member -NotePropertyName $tempName -NotePropertyValue $_.Value 
                            }
                        }
                        #Key is in UserSecurity segment
                        else {
                            if ($_.Key -eq "UserType") {
                                $User.userSecurity.userTypeString = $_.Value
                            }
                            else {
                                if ($_.Key -in $User.userSecurity.PSObject.Properties.Name) {
                                    $User.userSecurity.($_.Key) = $_.Value
                                }
                                else {
                                    $User.userSecurity | Add-Member -NotePropertyName $_.Key -NotePropertyValue $_.Value
                                } 
                            }
                        }
                    }
                }
            }

            $User.userSecurity.repositoryEntities = @{}

            $RequestParams = @{
                URI    = $URI
                Method = "PUT"
                Body   = $User | ConvertTo-Json
            }

            $res = Invoke-DS @RequestParams -Verbose
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose "[Update-DSUser] Begining..."
        }
        else {
            Write-Verbose "[Update-DSUser] Ended with errors..."
        }
    }
}