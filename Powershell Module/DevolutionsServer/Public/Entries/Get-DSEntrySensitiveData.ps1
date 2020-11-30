function Get-DSEntrySensitiveData{
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
            Write-Verbose '[Get-DSEntrySensitiveData] begin...'
            if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
          }
    
        PROCESS {
            [ServerResponse]$response = Get-DSEntrySensitiveDataLegacy @PSBoundParameters
            return $response
        }
    
        END {
           If ($?) {
              Write-Verbose '[Get-DSEntrySensitiveData] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSEntrySensitiveData] ended with errors...'
            }
        }
    }