function Get-DSEntriesPermissions{
    <#
        .SYNOPSIS
        Gets the permissions for all entries in a vault
        .DESCRIPTION
        Recursivly gets all permissions for all entries in a given vault.
        .EXAMPLE
        Get-DSEntriesPermissions -vaultId $vaultID -vaultName $vaultName
        .NOTES
        Used to get permissions report (See 'Sample' folder), but we made it available for use.
    #>
        [CmdletBinding()]
        param(			
            [ValidateNotNullOrEmpty()]
            [string]$VaultId,
            [string]$VaultName
        )
        
        BEGIN {
            Write-Verbose '[Get-DSEntriesPermissions] Beginning...'
        }
    
        PROCESS {
            try
            {   
                $PSBoundParameters.Remove('VaultName') | out-null
                [ServerResponse] $response = Get-DSEntriesTree @PSBoundParameters

                if (!$response.isSuccess)
                { 
                    Write-Verbose "[Get-DSEntriesPermissions] Got $($response)"
                }

                # we receive the hidden "root" folder that exists for all vaults
                # we must drill down in its PartialConnections objects to descend
                # in the hierarchy
                $root = $response.Body.Data

                $results = ListPermissionsRecursive -Folder $root -VaultName $VaultName
                return $results
            }
            catch
            {
                $exc = $_.Exception
                If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                        Write-Debug "[Exception] $exc"
                } 
            }
        }
    
        END {
            Write-Verbose '[Get-DSEntriesPermissions] ...end'
        }
    }