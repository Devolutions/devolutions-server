function New-DSCustomUser {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param(
        #Passthrough switch param
        [switch]$IKnowWhatImDoing,

        #Base
        [ValidateNotNullOrEmpty()]
        [string]$name,
        [ValidateNotNullOrEmpty()]
        [string]$password,

        [string]$firstName,
        [string]$lastName,

        [bool]$sendEmailInvite,

        #userAccount
        [bool]$isChangePasswordAllowed,
        [string]$email,
        [bool]$userMustChangePasswordAtNextLogin,

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
        Write-Verbose '[New-DSCustomUser] Beginning...'
        $URI = "$Script:DSBaseURI/api/security/user/save?csToXml=1"

        $userId = [guid]::NewGuid()

        $fullName = if ($firstName -and !$lastName) { $firstName } 
        elseif (!$firstName -and $lastName) { $lastName }
        elseif ( $firstName -and $lastName ) { "$firstName $lastName" }
        else { "" }

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    PROCESS {       
        $params = @{
            Uri    = $URI
            Method = 'PUT'
            Body   = @{}
        }

        #Passthrough approach. Only for experimented user that knows what they're doing.
        if ($IKnowWhatImDoing) {
            $PSBoundParameters.GetEnumerator() | ForEach-Object { $params.Body[$_.Key] = $_.Value }
        }
        #Hand holding approach
        else {
            $userAccountData = @{
                isChangePasswordAllowed           = $isChangePasswordAllowed
                password                          = $password
                email                             = if ($email) { $email } else { "" }
                fullName                          = if ($firstName -and !$lastName) { $firstName }
                elseif (!$firstName -and $lastName) { $lastName } 
                elseif ($firstName -and $lastName) { "$firstName $lastName" }
                else { "" }
                userMustChangePasswordAtNextLogin = $userMustChangePasswordAtNextLogin
            }

            $userProfileData = @{
                address       = $address
                cellPhone     = $cellPhone
                companyName   = $companyName
                countryName   = $countryName
                department    = $department
                fax           = $fax
                firstName     = $firstName
                gravatarEmail = $gravatarEmail
                jobTitle      = $jobTitle
                lastName      = $lastName
                phone         = $phone
                state         = $state
                workphone     = $workphone
            }

            $userSecurityData = @{
                userType            = $userType
                userLicenseTypeMode = $userLicenseTypeMode
                authenticationType  = $authenticationType
                name                = $name
            }

            $userAccount = Get-DSUserAccountSegment @userAccountData
            $userProfile = Get-DSUserProfileSegment @userProfileData    
            $userSecurity = Get-DSUserSecuritySegment @userSecurityData
    
            $newUserData = @{
                allGroups       = @()
                display         = $name
                groups          = @()
                roleGroups      = @()
                roles           = @()
                sendEmailInvite = if ($sendEmailInvite) { $sendEmailInvite } else { $false }
                id              = $userId
                key             = $userId
                userAccount     = $userAccount
                userProfile     = $userProfile
                userSecurity    = $userSecurity
            }
        }

        $params.Body = $newUserData | ConvertTo-Json

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