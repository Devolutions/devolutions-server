function New-DSVault {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [string]$Name = $(throw "Vault name is null or empty. Please provide a valid vault name and try again."),
        [string]$Password,
        [string]$Description = "",
        [bool]$IsAllowedOffline = $true,
        [string[]]$AllowedUsernameList = @(),
        [string[]]$AllowedApplicationList = @(),
        [string[]]$AllowedRolesList = @()
    )
    
    BEGIN {
        Write-Verbose "[New-DSVault] Begining..."

        $URI = "$env:DS_URL/api/security/repositories"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            #Generating ID for new vault
            $id = [guid]::NewGuid()

            #Getting users, applications and roles list
            $Application = if (($res = Invoke-DS -URI "$env:DS_URL/api/security/application/users/list" -Method "GET").isSuccess) { $res.Body.data } else { $null }
            $Roles = if (($res = Invoke-DS "$env:DS_URL/api/security/roles/basic" -Method "GET").isSuccess) { $res.Body.data } else { $null }

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
                    "quickAddEntries"    = @()
                    "masterPasswordHash" = $null
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