function Get-DSEntriesTree{
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        [OutputType([ServerResponse])]
        param(			
            [ValidateNotNullOrEmpty()]
            [guid]$VaultId
        )
        
        BEGIN {
            Write-Verbose '[Get-DSEntriesTree] begin...'
    
            $URI = "$Script:DSBaseURI/api/connections/partial/tree/$($VaultId)"

    		if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {
            try
            {   
                Set-DSVaultsContext $VaultId

                $params = @{
                    Uri = $URI
                    Method = 'GET'
                    LegacyResponse = $true
                }

                Write-Verbose "[Get-DSEntriesTree] about to call $Uri"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    ####the entry representing the root should not be manipulated using a plain Connection pattern,
                    ####we'll remove it for now
                    #update, its hierarchical... we must therefore just return the children...
                    $newBody = $response.body.data.partialConnections
                    $response.Body.data = $newBody
                    Write-Verbose "[Get-DSEntriesTree] Got $($response.Body.data.Length)"
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
           If ($?) {
              Write-Verbose '[Get-DSEntriesTree] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSEntriesTree] ended with errors...'
            }
        }
    }