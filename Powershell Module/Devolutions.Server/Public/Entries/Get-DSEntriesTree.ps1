function Get-DSEntriesTree{
    <#
        .SYNOPSIS
        Gets entries's tree
        .DESCRIPTION
        Gets the full entries's tree for a given vault.
        .EXAMPLE
        Get-DSEntriesTree -VaultId $VaultId
        .NOTES
        Used to get permissions report (See 'Sample' folder), but we made it available for use.
    #>
        [CmdletBinding()]
        [OutputType([ServerResponse])]
        param(			
            [Parameter(Mandatory)]
            [string]$VaultId
        )
        
        BEGIN {
            Write-Verbose '[Get-DSEntriesTree] Beginning...'
    
    		if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {

            $URI = "$Script:DSBaseURI/api/connections/partial/tree/$($VaultId)"

            try
            {   
                Set-DSVaultsContext $VaultId | out-null

                $params = @{
                    Uri = $URI
                    Method = 'GET'
                    LegacyResponse = $true
                }

                Write-Verbose "[Get-DSEntriesTree] about to call $Uri"

                [ServerResponse] $response = Invoke-DS @params

                if (!$response.isSuccess)
                { 
                    Write-Verbose "[Get-DSEntriesTree] Got $($response)"
                }
                
                If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                    Write-Debug "[Response.Body] $($response.Body)"
                }

                return $response
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
            Write-Verbose '[Get-DSEntriesTree] ...end'
        }
    }