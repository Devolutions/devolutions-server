function Remove-DSPamProvider {
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
        [string]$ProviderID
    )
        
    BEGIN {
        Write-Verbose '[Remove-DSPamProvider] Begin...'
    
        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        if (![string]::IsNullOrWhiteSpace($ProviderID)) {
            $URI = "$Script:DSBaseURI/api/pam/providers/$ProviderID"
        } else {
            throw "Provider ID is null or not set. Please check if you have a valid Provider ID."
        }

        try {
            $params = @{
                Uri    = $URI
                Method = 'DELETE'
            }

            Write-Verbose "[Remove-DSPamProvider] About to call with ${params.Uri}"

            $response = Invoke-DS @params

            if ($response.isSuccess) { 
                Write-Verbose "[Remove-DSPamProviders] Provider deletion was successful"
            }

            return $response
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::Break -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
        
    }
    
    END {
        If ($?) {
            Write-Verbose '[Remove-DSPamProviders] Completed Successfully.'
        }
        else {
            Write-Verbose '[Remove-DSPamProviders] Ended with errors...'
        }
    }
}