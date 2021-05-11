function Set-DSVaultUsers {
    <#
    .SYNOPSIS
        Sets the allowed users for a given vault.
        .DESCRIPTION
        Sets which users have access to a given vault. If the "Update" flag is present and a supplied username is already a member of the vault, it will remove this user.
        .EXAMPLE
        No update flag, no users allowed
        Current users allowed in vault:
        None

        Set-DSVaultUsers @("User1", "User2")
        -> Allowed users: User1, User2
        .EXAMPLE
        No update flag, some users allowed
        Current users allowed in vault:
        User1, User2

        Set-DSVaultUsers @("User3")
        -> Allowed users: User3
        .EXAMPLE
        Update flag present, some users allowed (Add another)
        Current users allowed in vault:
        User1

        Set-DSVaultUsers @("User2") -Update 
        -> Allowed users: User1, User2
        .EXAMPLE
        Update flag present, some users allowed (Remove a user)
        Current users allowed in vault:
        User1, User2

        Set-DSVaultUsers @("User2", "User3") -Update 
        -> Allowed users: User1, User3
    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        #Vault's ID to update
        [guid]$VaultID,
        #String array with application names (Not ID's) to allow in vault
        [string[]]$AllowedUsernameList,
        #Used to know if we're creating a vault or updating a currently existing one
        [switch]$Update
    )

    PROCESS {
        try {
            [object[]]$Users = if ($Update) {
                (Invoke-DS -URI "$Script:DSBaseURI/api/security/repositories/$VaultID/users" -Method "GET").Body.data
            }
            else {
                if (($res = Invoke-DS -URI "$Script:DSBaseURI/api/security/users/list" -Method "GET").isSuccess) { 
                    if ($res.Body.data.Length -eq 0) { throw "No users were found." }
                    $res.Body.data 
                } 
                else {
                    throw "Error getting user list." 
                }
            }

            $UserListToSave = @()

            $Users.GetEnumerator() | ForEach-Object {                
                $UserListToSave += @{
                    description     = ""
                    gravatarUrl     = ""
                    isAdministrator = if ($_.isAdministrator) { $true } else { $false }
                    isMember        = if ($Update) {
                        if ($_.name -in $AllowedUsernameList) {
                            if ($_.isMember) {
                                $false
                                Write-Warning "Removed $($_.name) from allowed users."
                            }
                            else { $true }                
                        }
                        else { $_.isMember }            
                    }
                    else { 
                        if ($_.name -in $AllowedUsernameList) { $true } else { $false } 
                    }
                    isRole          = $false
                    name            = $_.name
                    repositoryId    = $VaultID
                    userId          = if ($Update) { $_.userId } else { $_.id }
                }
            }

            $RequestParams = @{
                URI    = "$Script:DSBaseURI/api/security/repositories/$VaultID/users"
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