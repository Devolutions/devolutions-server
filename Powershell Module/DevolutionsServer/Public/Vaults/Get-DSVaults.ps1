function Get-DSVaults{
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        param(			
            [ValidateSet("Name", "Description")]
            [string]$SortField = '',
            [System.Management.Automation.SwitchParameter]$Descending,
            [int]$PageNumber = 1,
            [int]$PageSize = 25,
            [Switch]$Legacy 
        )
        
        BEGIN {
            Write-Verbose '[Get-DSVaults] begin...'
            if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
          }
    
        PROCESS {
            [ServerResponse]$response = $null

            $LegacyRequested = $Legacy.IsPresent
            $PSBoundParameters.Remove('Legacy') | out-null

            [System.Version]$ModernVersion = '2020.3.8.0'
            [System.Version]$v = $Global:DSInstanceVersion
            
            if (($LegacyRequested) -or ($v.CompareTo($ModernVersion) -lt 0)){
                $response = Get-DSVaultsLegacy @PSBoundParameters
            }
            else {
                $response = Get-DSVaultsModern @PSBoundParameters
            }

            return $response
        }
    
        END {
           If ($?) {
              Write-Verbose '[Get-DSVaults] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSVaults] ended with errors...'
            }
        }
    }