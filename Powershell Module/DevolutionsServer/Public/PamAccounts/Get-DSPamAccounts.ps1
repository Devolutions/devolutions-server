function Get-DSPamAccounts{
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
            Write-Verbose '[Get-DSPamAccounts] begin...'
    
            $URI = "$Script:DSBaseURI/api/pam/credentials"

    		if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken))
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
                    #LegacyResponse = $true
                }

                Write-Verbose "[Get-DSPamAccounts] about to call with $params.Uri"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    Write-Verbose "[Get-DSPamAccounts] was successfull"
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
              Write-Verbose '[Get-DSPamAccounts] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSPamAccounts] ended with errors...'
            }
        }
    }