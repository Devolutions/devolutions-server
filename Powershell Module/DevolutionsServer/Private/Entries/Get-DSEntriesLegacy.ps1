function Get-DSEntriesLegacy{
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
            [Parameter(Mandatory)]
            [string]$VaultId
        )
        
        BEGIN {
            Write-Verbose '[Get-DSEntriesLegacy] begin...'
    
            $URI = "$Global:DSBaseURI/api/Connections/list/all"

    		if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {
            try
            {   
                $ctx = Set-DSVaultsContext $VaultId

                $params = @{
                    Uri = $URI
                    Method = 'GET'
                    LegacyResponse = $true
                }

                Write-Verbose "[Get-DSEntriesLegacy] about to call $Uri"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    #the entry representing the root should not be manipulated using a plain Connection pattern,
                    #we'll remove it for now
                    $newBody = $response.body.data | Where-Object {$_.connectionType -ne '92'}
                    $response.Body.data = $newBody
                    Write-Verbose "[Get-DSEntriesLegacy] Got $($response.Body.data.Length)"
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
              Write-Verbose '[Get-DSEntriesLegacy] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSEntriesLegacy] ended with errors...'
            }
        }
    }