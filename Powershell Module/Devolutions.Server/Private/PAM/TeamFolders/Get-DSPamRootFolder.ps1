function Get-DSPamRootFolder {
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
        Write-Verbose '[New-DSPamRootFolder] Beginning...'
    }
    
    PROCESS {
        try {   	

            [ServerResponse] $response = Get-DSPamFolders -IncludeRoot
                if ($null -ne $response.Body.data) {
                    if ($response.Body.data -is [system.array]) {
                        $root = $response.Body.data | Where-Object { $true -eq $_.isRoot }
                        #the @() ensures that its an array even if 0 or 1 results
                        $response.Body.data = @($root)
                    }
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
        If ($?) {
            Write-Verbose '[New-DSPamRootFolder] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamRootFolder] ended with errors...'
        }
    }
}