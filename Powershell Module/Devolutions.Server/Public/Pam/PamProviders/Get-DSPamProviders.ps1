function Get-DSPamProviders {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    param(			
    )
        
    BEGIN {
        Write-Verbose '[Get-DSPamProviders] Beginning...'
    
        $URI = "$Script:DSBaseURI/api/pam/providers"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
                        throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {   	
            $params = @{
                Uri            = $URI
                Method         = 'GET'
                #LegacyResponse = $true
            }

            Write-Verbose "[Get-DSPamProviders] about to call with $params.Uri"

            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Response.Body] $($response.Body)"
            }

            [ServerResponse] $response = Invoke-DS @params
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
            Write-Verbose '[Get-DSPamProviders] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSPamProviders] Ended with errors...'
        }
    }
}