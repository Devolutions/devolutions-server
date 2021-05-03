function Get-DSVaultsLegacy{
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
        )
        
        BEGIN {
            Write-Verbose '[Get-DSVaultsLegacy] begin...'
    
            $URI = "$Global:DSBaseURI/api/security/vaults"

    		if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {
            try
            {   	
                $params = @{
                    Uri = $URI
                    Method = 'GET'
                    LegacyResponse = $true
                }

                Write-Verbose "[Get-DSVaultsLegacy] about to call with $params.Uri"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    Write-Verbose "[Get-DSVaultsLegacy] Got $($response.Body.data.Length)"
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
              Write-Verbose '[Get-DSVaultsLegacy] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSVaultsLegacy] ended with errors...'
            }
        }
    }