function Update-DSCustomUser {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param(
        #Base
        [ValidateNotNullOrEmpty()]
        [guid]$candidUserId,
        [string]$firstName,
        [string]$lastName,

        #userAccount
        [string]$email,
        [bool]$userMustChangePasswordAtNextLogin,
        [bool]$isChangePasswordAllowed,

        #userProfile
        [string]$address,
        [string]$cellPhone,
        [string]$companyName,
        [string]$countryName,
        [string]$culture,
        [string]$department,
        [string]$fax,
        [string]$gravatarEmail,
        [string]$jobTitle,
        [string]$phone,
        [string]$state,
        [string]$workphone,

        #userSecurity
        [bool]$isAdministrator,
        [bool]$isEnabled,
        [bool]$isLockedOut,
        [bool]$canAdd,
        [bool]$canDelete,
        [bool]$canEdit,
        [string]$customSecurity,
        [bool]$canAddCredentials,
        [bool]$canAddDataEntry,
        [bool]$canDeleteCredentials,
        [bool]$canDeleteDataEntry,
        [bool]$canEditCredentials,
        [bool]$canEditDataEntry,
        [string]$UPN,
        [string]$loginEmail,
        [bool]$hasAccessRDM,
        [bool]$hasAccessWeb,
        [bool]$hasAccessWebLogin,
        [bool]$hasAccessLauncher,
        [bool]$hasAccessCli,
        [int]$userType,
        [int]$userLicenseTypeMode,
        [int]$authenticationType
    )

    BEGIN {
        Write-Verbose '[Update-DSCustomUser] Beginning...'
        $URI = "$Global:DSBaseURI/api/security/user/save?csToXml=1"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }

        $currentUserData = (Get-DSUsers -candidUserId $candidUserId -Verbose).Body
       
        if ($null -eq $currentUserData) {
            throw "User couldn't be found and operation was abborted."
        }
    }
    PROCESS {   
        $params = @{
            Uri    = $URI
            Method = 'PUT'
            Body   = @{}
        }

        $PSBoundParameters.GetEnumerator() | ForEach-Object {
            if ($_.Key -ne 'candidUserId') {
                #userAccount
                if (('isChangePasswordAllowed', 'email', 'userMustChangePasswordAtNextLogin') -contains $_.Key) {
                    if ($currentUserData.userAccount[$_.Key] -ne $_.Value) {
                        $currentUserData.userAccount[$_.Key] = $_.Value
                    }
                }
                #userProfile
                elseif (('address', 'cellPhone', 'companyName', 'countryName', 'department', 'fax', 'firstName', 'gravatarEmail', 'jobTitle', 'phone', 'phone', 'state', 'workphone') -contains $_.Key) {
                    if ($currentUserData.userProfile[$_.Key] -ne $_.Value) {
                        $currentUserData.userProfile[$_.Key] = $_.Value
                    }
                }
                #userSecurity
                elseif (('isChangePasswordAllowed', 'email', 'userMustChangePasswordAtNextLogin') -contains $_.Key) {
                    if ($currentUserData.userSecurity[$_.Key] -ne $_.Value) {
                        $currentUserData.userSecurity[$_.Key] = $_.Value
                    }
                }  
            }  
        }

        $params.Body = $currentUserData | ConvertTo-Json

        $res = Invoke-DS @params
        return $res
    }
    END {
        If ($res.isSuccess) {
            Write-Verbose '[New-DSCustomUser] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSCustomUser] Ended with errors...'
        }
    }
}