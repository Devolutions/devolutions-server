function Get-DSEntryLegacy{
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
            Write-Verbose '[Get-DSEntryLegacy] begin...'
    
            $URI = "$Script:DSBaseURI/api/Connections/partial/$($EntryId)"

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
                    LegacyResponse = $true
                }

                Write-Verbose "[Get-DSEntryLegacy] about to call $Uri"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    Write-Verbose "[Get-DSEntryLegacy] Got $($response.Body.Length)"
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
                Write-Verbose '[Get-DSEntryLegacy] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSEntryLegacy] ended with errors...'
            }
        }
    }