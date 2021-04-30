function Set-DSVaultApplications {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$VaultID,
        [string[]]$AllowedApplicationsList,
        [switch]$Update
    )

    PROCESS {
        try {
            [object[]]$Applications = if ($Update) {
                (Invoke-DS -URI "$env:DS_URL/api/security/repositories/$VaultID/applications" -Method "GET").Body.data
            }
            else {
                if (($res = Invoke-DS -URI "$env:DS_URL/api/security/application/users/list" -Method "GET").isSuccess) { 
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
                URI    = "$env:DS_URL/api/security/repositories/$VaultID/applications"
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