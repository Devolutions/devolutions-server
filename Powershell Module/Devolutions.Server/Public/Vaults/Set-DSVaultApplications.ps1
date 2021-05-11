function Set-DSVaultApplications {
    <#
        .SYNOPSIS
        Sets the allowed applications for a given vault.
        .DESCRIPTION
        Sets which application have access to a given vault. If the "Update" flag is present and a supplied application name is already a member of the vault, it will remove this application.
        .EXAMPLE
        No update flag, no applications allowed
        Current applications allowed in vault:
        None

        Set-DSVaultApplications @("App1", "App2")
        -> Allowed applications: App1, App2
        .EXAMPLE
        No update flag, some applications allowed
        Current applications allowed in vault:
        App1, App2

        Set-DSVaultApplications @("App3")
        -> Allowed applications: App3
        .EXAMPLE
        Update flag present, some applications allowed (Add another)
        Current applications allowed in vault:
        App1

        Set-DSVaultApplications @("App2") -Update 
        -> Allowed applications: App1, App2
        .EXAMPLE
        Update flag present, some applications allowed (Remove an application)
        Current applications allowed in vault:
        App1, App2

        Set-DSVaultApplications @("App2", "App3") -Update 
        -> Allowed applications: App1, App3
    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        #Vault's ID to update
        [guid]$VaultID,
        #String array with application names (Not ID's) to allow in vault
        [string[]]$AllowedApplicationsList,
        #Used to know if we're creating a vault or updating a currently existing one
        [switch]$Update
    )

    PROCESS {
        try {
            [object[]]$Applications = if ($Update) {
                (Invoke-DS -URI "$Script:DSBaseURI/api/security/repositories/$VaultID/applications" -Method "GET").Body.data
            }
            else {
                if (($res = Invoke-DS -URI "$Script:DSBaseURI/api/security/application/users/list" -Method "GET").isSuccess) { 
                    if ($res.Body.data.Length -eq 0) { throw "No applications were found." }
                    $res.Body.data
                } 
                else { 
                    throw "Error getting roles list." 
                }
            }

            $ApplicationsListToSave = @()

            $Applications.GetEnumerator() | ForEach-Object {                
                $ApplicationsListToSave += @{
                    description     = if ($Update) { $_.description } else { $_.fullName }
                    gravatarUrl     = ""
                    isAdministrator = if ($_.isAdministrator) { $true } else { $false }
                    isMember        = if ($Update) {
                        if ($_.description -in $AllowedApplicationsList) {
                            if ($_.isMember) {
                                $false
                                Write-Warning "Removed $($_.description) from allowed applications."
                            }
                            else { $true }
                        }
                        else { $_.isMember }
                    }
                    else {
                        if ($_.fullName -in $AllowedApplicationsList) { $true } else { $false }
                    }
                    isRole          = $false
                    name            = $_.name
                    repositoryId    = $VaultID
                    userId          = if ($Update) { $_.userId } else { $_.id }
                }
            }

            $RequestParams = @{
                URI    = "$Script:DSBaseURI/api/security/repositories/$VaultID/applications"
                Method = "PUT"
                Body   = ConvertTo-Json $ApplicationsListToSave
            }

            $res = Invoke-DS @RequestParams -Verbose
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
}