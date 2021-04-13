function Get-DSPamFolders {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    param(		
        [switch]$IncludeRoot
    )
        
    BEGIN {
        Write-Verbose '[Get-DSPamFolders] begin...'
    
        $URI = "$Script:DSBaseURI/api/pam/folders"

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {   	
            $params = @{
                Uri            = $URI
                Method         = 'GET'
                LegacyResponse = $true
            }

            Write-Verbose "[Get-DSPamFolders] about to call with $params.Uri"

            [ServerResponse] $response = Invoke-DS @params

            #a "root" folder is returned that is more akin to a hidden placeholder for defaults.
            #we do need it for creating folders at the root though...
            if ($false -eq $IncludeRoot.IsPresent) {
                if ($null -ne $response.Body.data) {
                    if ($response.Body.data -is [system.array]) {
                        $root = $response.Body.data | Where-Object { $true -eq $_.isRoot }
                        #the @() ensures that its an array even if 0 or 1 results
                        $response.Body.data = @($response.Body.data | Where-Object { $_ -ne $root })
                    }
                }
            }

            if ($response.isSuccess) { 
                Write-Verbose "[Get-DSPamFolders] was successfull"
            }

            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Response.Body] $($response.Body)"
            }

            return $response
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
    }
    
    END {
        If ($response.isSuccess) {
            Write-Verbose '[Get-DSPamFolders] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSPamFolders] ended with errors...'
        }
    }
}