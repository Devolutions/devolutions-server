function Get-DSSecureMessages{
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        param(			
        )
        
        BEGIN {
            Write-Verbose '[Get-DSSecureMessage] begin...'
    
            $URI = "$Global:DSBaseURI/api/secure-messages"

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

                Write-Verbose "[Get-DSSecureMessage] about to call with $params.Uri"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    Write-Verbose "[Get-DSSecureMessage] was successfull"
                }

                foreach ($item in $response.Body.data) {
                    $decryptedinfo = Decrypt-String $Global:DSSessionKey $item.JsonData
                    $item.JsonData = $decryptedinfo
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
              Write-Verbose '[Get-DSSecureMessage] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSSecureMessage] ended with errors...'
            }
        }
    }