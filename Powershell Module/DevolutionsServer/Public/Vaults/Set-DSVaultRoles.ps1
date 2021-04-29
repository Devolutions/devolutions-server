function Set-DSVaultRoles {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$VaultID,
        [string[]]$AllowedRolesList
    )

    PROCESS {
        try {
            [object[]]$Roles = if (($res = Invoke-DS -URI "$env:DS_URL/api/security/roles/basic" -Method "GET").isSuccess) {
                if ($res.Body.data.Length -eq 0) { throw "No roles were found." }
                $res.Body.data
            } 
            else { 
                throw "Error getting roles list." 
            }

            $RolesListToSave = @()

            $Roles.GetEnumerator() | ForEach-Object {                
                $RolesListToSave += @{
                    description     = ""
                    gravatarUrl     = ""
                    isAdministrator = if ($_.isAdministrator) { $true } else { $false }
                    isMember        = if ($_.name -in $AllowedRolesList) { $true } else { $false }
                    isRole          = $false
                    name            = $_.name
                    repositoryId    = $VaultID
                    userId          = $_.id
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