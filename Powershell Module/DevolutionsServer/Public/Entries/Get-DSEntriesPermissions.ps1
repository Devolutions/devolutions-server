function Get-DSEntriesPermissions{
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        param(			
            [ValidateNotNullOrEmpty()]
            [string]$VaultId,
            [string]$VaultName
        )
        
        BEGIN {
            Write-Verbose '[Get-DSEntriesPermissions] begin...'
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