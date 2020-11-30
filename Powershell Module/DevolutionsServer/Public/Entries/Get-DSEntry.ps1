function Get-DSEntry{
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        param(			
            [Parameter(Mandatory)]
            [string]$EntryId       
        )
        
        BEGIN {
            Write-Verbose '[Get-DSEntry] begin...'
            if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
          }
    
        PROCESS {
            [ServerResponse]$response = Get-DSEntryLegacy @PSBoundParameters
            return $response
        }
    
        END {
           If ($?) {
              Write-Verbose '[Get-DSEntry] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSEntry] ended with errors...'
            }
        }
    }