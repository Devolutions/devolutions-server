function Set-DSVaultApplications {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$VaultID,
        [string[]]$AllowedApplicationsList
    )

    PROCESS {
        try {
            [object[]]$Applications = if (($res = Invoke-DS -URI "$env:DS_URL/api/security/application/users/list" -Method "GET").isSuccess) { 
                if ($res.Body.data.Length -eq 0) { throw "No applications were found." }
                $res.Body.data
            } 
            else { 
                throw "Error getting roles list." 
            }

            $ApplicationsListToSave = @()

            $Applications.GetEnumerator() | ForEach-Object {                
                $ApplicationsListToSave += @{
                    description     = $_.fullName
                    gravatarUrl     = ""
                    isAdministrator = if ($_.isAdministrator) { $true } else { $false }
                    isMember        = if ($_.fullName -in $AllowedApplicationsList) { $true } else { $false }
                    isRole          = $false
                    name            = $_.name
                    repositoryId    = $VaultID
                    userId          = $_.id
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