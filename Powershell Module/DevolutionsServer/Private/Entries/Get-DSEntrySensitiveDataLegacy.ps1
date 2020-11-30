function Get-DSEntrySensitiveDataLegacy{
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
            [string]$EntryId
        )
      
        BEGIN {
            Write-Verbose '[Get-DSEntrySensitiveDataLegacy] begin...'
    
            $URI = "$Script:DSBaseURI/api/Connections/partial/$($EntryID)/sensitive-data"

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
                    Method = 'POST' #???
                    LegacyResponse = $true
                }

                Write-Verbose "[Get-DSEntrySensitiveDataLegacy] about to call $Uri"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    Write-Verbose "[Get-DSEntrySensitiveDataLegacy] Got $($response.Body.Length)"
                }
                
                If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                        Write-Debug "[Response.Body] $($response.Body)"
                }

                $decryptedinfo = Decrypt-String $Script:DSSessionKey $response.Body.Data
                $response.Body.data = $decryptedinfo
            
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
              Write-Verbose '[Get-DSEntrySensitiveDataLegacy] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSEntrySensitiveDataLegacy] ended with errors...'
            }
        }
    }