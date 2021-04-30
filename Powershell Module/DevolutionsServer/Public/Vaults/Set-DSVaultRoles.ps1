function Set-DSVaultRoles {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$VaultID,
        [string[]]$AllowedRolesList,
        [switch]$Update
    )

    PROCESS {
        try {
            [object[]]$Roles = if ($Update) {
                (Invoke-DS -URI "$env:DS_URL/api/security/repositories/$VaultID/roles" -Method "GET").Body.data
            }
            else {
                if (($res = Invoke-DS -URI "$env:DS_URL/api/security/roles/basic" -Method "GET").isSuccess) {
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
                URI    = "$env:DS_URL/api/security/repositories/$VaultID/roles"
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