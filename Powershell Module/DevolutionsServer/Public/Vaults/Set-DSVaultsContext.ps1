function Set-DSVaultsContext{
    <#
    .SYNOPSIS
    The Legacy API still has a "current" Vault in context.
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        [OutputType([ServerResponse])]
        param(			
            [Parameter(Mandatory)]
            [string]$vaultId
        )
        
        BEGIN {
            Write-Verbose '[Set-DSVaultsContext] begin...'
    
            $URI = "$Script:DSBaseURI/api/security/vaults/change"

    		if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {
            try
            {   	
                $params = @{
                    Uri         = $URI
                    Method      = 'PUT'
                    Body = """$vaultId"""
                }

                Write-Verbose "[Set-DSVaultsContext] about to call with $params.Uri"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    $content = $response.originalResponse.Content | ConvertFrom-Json
                    Write-Verbose "[Set-DSVaultsContext] $($content)"
                }
                
                If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                        Write-Debug "[Response.Body] $($response.Body)"
                }

                return $response
            }
            catch
            {
                $exc = $_.Exception
                Write-Verbose '[Set-DSVaultsContext] Exception occurred ...'
                If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                        Write-Debug "[Exception] $exc"
                } 
            }
        }
    
        END {
            Write-Verbose '[Set-DSVaultsContext] End'
        }
    }