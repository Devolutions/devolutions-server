function New-DSVault {
    <#
        .SYNOPSIS
        Creates a new vault.
        .DESCRIPTION
        Creates a new vault and add users, applications and roles to it if the respective list is supplied.
        .EXAMPLE
        $Vault = @{
                Name                   = 'NewVault'
                Description            = 'This is a description for the new vault.'
                IsAllowedOffline       = $true
                Password               = 'Pa$$w0rd!'
                AllowedUsernameList    = @("User1")
                AllowedRolesList       = @("Role1", "Role2")
                AllowedApplicationList = @("App1")
            }

            $response = New-DSVault @Vault
    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        #Vault's name
        [string]$Name = $(throw "Vault name is null or empty. Please provide a valid vault name and try again."),
        #Vault's master password. Backend does not verify password complexity, so you should use New-DSPassword and choose a password in the list
        [string]$Password,
        #Vault's description
        [string]$Description = "",
        #Specify if the vault is allowed to be used while offline
        [bool]$IsAllowedOffline = $true,
        #Accept an array of strings containing usernames (not id) to add to the vault
        [string[]]$AllowedUsernameList = @(),
        #Accept an array of strings containing application names (not app id) to add to the vault
        [string[]]$AllowedApplicationList = @(),
        #Accept an array of strings containing user group's name (not id) to add to the vault
        [string[]]$AllowedRolesList = @()
    )
    
    BEGIN {
        Write-Verbose "[New-DSVault] Beginning..."

        $URI = "$Script:DSBaseURI/api/security/repositories"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            #Generating ID for new vault
            $id = [guid]::NewGuid()

            #Getting users, applications and roles list
            $Application = if (($res = Invoke-DS -URI "$Script:DSBaseURI/api/security/application/users/list" -Method "GET").isSuccess) { $res.Body.data } else { $null }
            $Roles = if (($res = Invoke-DS "$Script:DSBaseURI/api/security/roles/basic" -Method "GET").isSuccess) { $res.Body.data } else { $null }

            #Setting new vault data
            $NewVault = @{
                description            = $Description
                hasPasswordChanged     = if ($Password) { $true } else { $false }
                id                     = $id
                idString               = $id.ToString()
                image                  = ""
                imageBytes             = ""
                imageName              = ""
                isAllowedOffline       = $IsAllowedOffline
                isLocked               = $false
                isPrivate              = $false
                modifiedLoggedUserName = ""
                modifiedUserName       = ""
                name                   = $Name
                repositorySettings     = @{
                    quickAddEntries    = @()
                    masterPasswordHash = $null
                }
                selected               = $false
            }

            #Encryp password, if need be
            if ($Password) {
                $EncryptedPassword = Protect-ResourceToHexString $Password
                $NewVault | Add-Member -NotePropertyName "password" -NotePropertyValue $EncryptedPassword
                $NewVault | Add-Member -NotePropertyName "passwordDisplayValue" -NotePropertyValue "●●●●●●"
            }

            $RequestParams = @{
                URI    = $URI
                Method = "PUT"
                Body   = $NewVault | ConvertTo-Json
            }

            $res = Invoke-DS @RequestParams -Verbose
            if (!$res.isSuccess) { return $res } #If backend couldn't process vault for whatever reason, return here and do not proceed

            if ((0 -ne $AllowedUsernameList.Count) -and (!(Set-DSVaultUsers $id $AllowedUsernameList).isSuccess)) { Write-Warning "[New-DSVault] Users could not be added to vault." }
            if ((0 -ne $AllowedRolesList.Count) -and (!(Set-DSVaultRoles $id $AllowedRolesList).isSuccess)) { Write-Warning "[New-DSVault] Roles could not be added to vault." }
            if ((0 -ne $AllowedApplicationList.Count) -and (!(Set-DSVaultApplications $id $AllowedApplicationList).isSuccess)) { Write-Warning "[New-DSVault] Applications could not be added to vault." }

            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose "[New-DSVault] Completed successfully!"
        }
        else {
            Write-Verbose "[New-DSVault] Ended with errors..."
        }
    }
}