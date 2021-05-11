function Update-DSVault {
    <#
        .SYNOPSIS
        Updates a vault.
        .DESCRIPTION
        Updates a vault using the supplied parameters. If name is present, it cannot be null nor empty. Backend does not verify password complexity, so use New-DSPassword to generate a strong password with house policy.
        .EXAMPLE
        $UpdatedVault = @{
                VaultID                = "36120922-539d-4550-8567-fc4f21d77352"
                Name                   = "Test"
                Description            = "Test"
                IsAllowedOffline       = $false
                Password               = 'Pa$$w0rd!'
                AllowedUsersList       = @("User1")
                AllowedRolesList       = @("Role1")
                AllowedApplicationList = @("App1")
            }

            Update-DSVault @NewVault -Verbose
    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        #Vault's ID to update
        [guid]$VaultID = $(throw "Vault ID is null or empty. Please provide a valid vault ID and try again."),
        #Vault's name
        [string]$Name,
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
        Write-Verbose "[Update-DSVault] Beginning..."

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            if (!($res = Get-DSVault $VaultID).isSuccess) {
                throw "Vault could not be found. Make sure you are using a valid vault ID or try creating a new one instead (New-DSVault)."
            }

            $VaultCtx = $res.Body.data

            if ("Name" -in $PSBoundParameters.Keys) {
                if ([string]::IsNullOrWhiteSpace($Name)) {
                    throw "You cannot update the vault's name with a null or empty value. Please provide a valid name for the vault or remove the field."
                }
            }

            $NewVault = @{
                description            = $Description
                hasPasswordChanged     = if ($Password) { $true } else { $false }
                id                     = $VaultID
                idString               = $VaultID.ToString()
                image                  = ""
                imageBytes             = ""
                imageName              = ""
                isAllowedOffline       = if ("IsAllowedOffline" -in $PSBoundParameters.Keys) { 
                    $IsAllowedOffline 
                }
                else { 
                    if ("isAllowedOffline" -in $VaultCtx.PSObject.Properties.Name) { $false } else { $true }
                }
                isLocked               = $false
                isPrivate              = $false
                modifiedLoggedUserName = ""
                modifiedUserName       = ""
                name                   = $Name
                repositorySettings     = @{
                    quickAddEntries    = @()
                    masterPasswordHash = ""
                }
                selected               = $false
            }

            if (![string]::IsNullOrWhiteSpace($VaultCtx.repositorySettings.masterPasswordHash) -or (![string]::IsNullOrWhiteSpace($Password))) {
                if (![string]::IsNullOrWhiteSpace($VaultCtx.repositorySettings.masterPasswordHash) -and ([string]::IsNullOrWhiteSpace($Password))) {
                    $NewVault.repositorySettings.masterPasswordHash = $VaultCtx.repositorySettings.masterPasswordHash
                }
                else {
                    $EncryptedPassword = Protect-ResourceToHexString $Password
                    $NewVault += @{"password" = $EncryptedPassword }
                    $NewVault.repositorySettings.masterPasswordHash = ""
                }

                $NewVault += @{"passwordDisplayValue" = "●●●●●●" }
            }

            if ((0 -ne $AllowedUsernameList.Count) -and (!(Set-DSVaultUsers $VaultID $AllowedUsernameList -Update).isSuccess)) { Write-Warning "[New-DSVault] Users could not be added to vault." }
            if ((0 -ne $AllowedRolesList.Count) -and (!(Set-DSVaultRoles $VaultID $AllowedRolesList -Update).isSuccess)) { Write-Warning "[New-DSVault] Roles could not be added to vault." }
            if ((0 -ne $AllowedApplicationList.Count) -and (!(Set-DSVaultApplications $VaultID $AllowedApplicationList -Update).isSuccess)) { Write-Warning "[New-DSVault] Applications could not be added to vault." }

            $RequestParams = @{
                URI    = "$Script:DSBaseURI/api/security/repositories"
                Method = "PUT"
                Body   = ConvertTo-Json $NewVault
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
            Write-Verbose "[Update-DSVault] Completed successfully!"
        }
        else {
            Write-Verbose "[Update-DSVault] Ended with errors..."
        }
    }
}