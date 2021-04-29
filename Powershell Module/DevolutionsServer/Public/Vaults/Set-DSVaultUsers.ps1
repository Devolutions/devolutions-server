function Set-DSVaultUsers {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$VaultID,
        [string[]]$AllowedUsernameList
    )

    PROCESS {
        try {
            $Users = if (($res = Invoke-DS -URI "$env:DS_URL/api/security/users/list" -Method "GET").isSuccess) { 
                if ($res.Body.data.Length -eq 0) { throw "No users were found." }
                $res.Body.data 
            } 
            else {
                throw "Error getting user list." 
            }

            $UserListToSave = @()

            $Users.GetEnumerator() | ForEach-Object {                
                $UserListToSave += @{
                    description     = ""
                    gravatarUrl     = ""
                    isAdministrator = if ($_.isAdministrator) { $true } else { $false }
                    isMember        = if ($_.name -in $AllowedUsernameList) { $true } else { $false }
                    isRole          = $false
                    name            = $_.name
                    repositoryId    = $VaultID
                    userId          = $_.id
                }
            }

            $RequestParams = @{
                URI    = "$env:DS_URL/api/security/repositories/$VaultID/users"
                Method = "PUT"
                Body   = ConvertTo-Json $UserListToSave
            }

            $res = Invoke-DS @RequestParams -Verbose
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
}