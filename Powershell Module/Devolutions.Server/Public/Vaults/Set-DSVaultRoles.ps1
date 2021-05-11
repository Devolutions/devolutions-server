function Set-DSVaultRoles {
    <#
    .SYNOPSIS
        Sets the allowed user groups for a given vault.
        .DESCRIPTION
        Sets which user groups have access to a given vault. If the "Update" flag is present and a supplied user group's name is already a member of the vault, it will remove this user group.
        .EXAMPLE
        No update flag, no user groups allowed
        Current user groups allowed in vault:
        None

        Set-DSVaultRoles @("Role1", "Role2")
        -> Allowed user groups: Role1, Role2
        .EXAMPLE
        No update flag, some user groups allowed
        Current user groups allowed in vault:
        Role1, Role2

        Set-DSVaultRoles @("Role3")
        -> Allowed user groups: Role3
        .EXAMPLE
        Update flag present, some user groups allowed (Add another)
        Current user groups allowed in vault:
        Role1

        Set-DSVaultRoles @("Role2") -Update 
        -> Allowed user groups: Role1, Role2
        .EXAMPLE
        Update flag present, some user groups allowed (Remove an user group)
        Current user groups allowed in vault:
        Role1, Role2

        Set-DSVaultRoles @("Role2", "Role3") -Update 
        -> Allowed user groups: Role1, Role3
    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        #Vault's ID to update
        [guid]$VaultID,
        #String array with user groups names (Not ID's) to allow in vault
        [string[]]$AllowedRolesList,
        #Used to know if we're creating a vault or updating a currently existing one
        [switch]$Update
    )

    PROCESS {
        try {
            [object[]]$Roles = if ($Update) {
                (Invoke-DS -URI "$Script:DSBaseURI/api/security/repositories/$VaultID/roles" -Method "GET").Body.data
            }
            else {
                if (($res = Invoke-DS -URI "$Script:DSBaseURI/api/security/roles/basic" -Method "GET").isSuccess) {
                    if ($res.Body.data.Length -eq 0) { throw "No roles were found." }
                    $res.Body.data
                } 
                else { 
                    throw "Error getting roles list." 
                }
            }

            $RolesListToSave = @()

            $Roles.GetEnumerator() | ForEach-Object {                
                $RolesListToSave += @{
                    description     = ""
                    gravatarUrl     = ""
                    isAdministrator = if ($_.isAdministrator) { $true } else { $false }
                    isMember        = if ($Update) {
                        if ($_.name -in $AllowedRolesList) {
                            if ($_.isMember) {
                                $false 
                                Write-Warning "Removed $($_.name) from allowed user groups."
                            }
                            else { $true }                        
                        }
                        else { $_.isMember }
                    }
                    else {
                        if ($_.name -in $AllowedRolesList) { $true } else { $false }
                    }
                    isRole          = $true
                    name            = $_.name
                    repositoryId    = $VaultID
                    userId          = if ($Update) { $_.userId } else { $_.id }
                }
            }

            $RequestParams = @{
                URI    = "$Script:DSBaseURI/api/security/repositories/$VaultID/roles"
                Method = "PUT"
                Body   = ConvertTo-Json $RolesListToSave
            }

            $res = Invoke-DS @RequestParams -Verbose
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
}