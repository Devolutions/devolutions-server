function Get-DSFolders{
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
     By default, it returns only the root level folders, this is by design to prevent 
     a huge compute charge for customers that have thousands of entries in their vaults
    .LINK
    #>
        [CmdletBinding()]
        param(			
            [ValidateNotNullOrEmpty()]
            [string]$VaultId,
            #TODO:improve to allow for a folder to start from
            [switch]$IncludeSubFolders
        )
        
        BEGIN {
            Write-Verbose '[Get-DSFolders] begin...'
            if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {
            $response = Get-DSEntriesTree @PSBoundParameters
            if ($response.IsSuccess) {
                if ($IncludeSubFolders.IsPresent) {
                    throw "Assertion : NotImplementedException"
                } else {
                    $toplevelFolders = $response.Body.Data | where-object {$_.connectionType -eq 25}
                    $response.Body.Data =[PSCustomObject]@($toplevelFolders)
                }
            }
            return $response
        }
    
        END {
              Write-Verbose '[Get-DSFolders] ...end'
        }
    }