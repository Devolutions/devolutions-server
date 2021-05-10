function Get-DSVault{
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
            [string]$VaultID
        )
        
        BEGIN {
            Write-Verbose '[Get-DSVault] begin...'
    

    		if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {
            $URI = "$Global:DSBaseURI/api/security/vaults/$($VaultID)"

            try
            {   	
                $params = @{
                    Uri = $URI
                    Method = 'GET'
                }

                Write-Verbose "[Get-DSVault] about to call with $($params.Uri)"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    Write-Verbose "[Get-DSVault] Got $($response.Body.data)"
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
              Write-Verbose '[Get-DSVault] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSVault] ended with errors...'
            }
        }
    }