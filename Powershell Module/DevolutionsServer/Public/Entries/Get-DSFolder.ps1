function Get-DSFolder{
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
            [Guid]$EntryId,
            [switch]$IncludeAdvancedProperties
        )
        
        BEGIN {
            Write-Verbose '[Get-DSFolder] begin...'
            if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
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
              Write-Verbose '[Get-DSFolder] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSFolder] ended with errors...'
            }
        }
    }