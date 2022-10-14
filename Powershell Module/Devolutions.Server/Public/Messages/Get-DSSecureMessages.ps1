function Get-DSSecureMessages{
    <#
        .SYNOPSIS
        Fetch all secure messages
        .DESCRIPTION
        Fetch all secure messages for the currently authenticated user,
        .EXAMPLE
        > Get-DSSecureMessages

        .NOTES
        It fetch messages for the user you logged in with (New-DSSession). For other users, you need to re-authenticate and type the command again.
    #>
        [CmdletBinding()]
        param(			
        )
        
        BEGIN {
            Write-Verbose '[Get-DSSecureMessage] Beginning...'
    
            $URI = "$Script:DSBaseURI/api/secure-messages"

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