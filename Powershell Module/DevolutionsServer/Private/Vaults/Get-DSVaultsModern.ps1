function Get-DSVaultsModern{
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
            <# TODO: in an ideal world, when more than 25 records are requested, we would take care of the paging in this module.
            Asking for a data set in a manner that would impact the whole system negatively should be at least be frowned upon, 
            but ideally the server would not even allow it. #>
            [int]$PageSize = 25
        )
        
        BEGIN {
            Write-Verbose '[Get-DSVaultsModern] begin...'
    
            $URI = "$Script:DSBaseURI/api/v3/vaults"

    		if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {
            try
            {   	
                $nvCollection = [System.Web.HttpUtility]::ParseQueryString([string]::Empty) 
                $nvCollection.Add('PageSize', $PageSize)
                $nvCollection.Add('PageNumber', $PageNumber)
                
                if (![string]::IsNullOrWhiteSpace($SortField))
                {
                    $nvCollection.Add('SortField', $SortField)
                    #the ternary operator appeared in PS 6... keep retro compatible for now
                    #$nvCollection.Add('SortOrder', $Descending ? -1 : 1)
                    if ($Descending){
                        $nvCollection.Add('SortOrder', -1)
                    }
                }
        
                $uriBuilder = [System.UriBuilder]::new($URI)
                $uriBuilder.Query = $nvCollection.ToString()

                $params = @{
                    Uri         = $uriBuilder.ToString()
                    Method      = 'GET'
                }

                Write-Verbose "[Get-DSVaultsModern] about to call with $params.Uri"

                [ServerResponse] $response = Invoke-DS @params

                if ($response.isSuccess)
                { 
                    Write-Verbose "[Get-DSVaultsModern] returned $($response.Body.data.Length) vaults, indicating that there are $($response.Body.totalCount) in total"
                }
                
                If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                        Write-Debug "[Response] $($response.Body)"
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
              Write-Verbose '[Get-DSVaultsModern] Completed Successfully.'
            } else {
                Write-Verbose '[Get-DSVaultsModern] ended with errors...'
            }
        }
    }