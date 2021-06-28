function Get-DSPamCheckoutPolicies {
    <#
        .SYNOPSIS
        Returns checkout policy(ies).
        .DESCRIPTION
        If a policy ID is supplied, it will try to fetch and return the policy matching to the ID. If no ID is supplied, it will return a list of all policies in place.
        .EXAMPLE
        > Get-DSPamCheckoutPolicies 
        Returns all checkout policies currently in place.
        
        .EXAMPLE
        > Get-DSPamCheckoutPolicies $PolicyID
        Returns the checkout policy, if found.
    #>
    [CmdletBinding()]
    param(
        #Policy ID (GUID)
        [guid]$policyID
    )
        
    BEGIN {
        Write-Verbose '[Get-DSPamCheckoutPolicies] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        try {  

            if (![string]::IsNullOrWhiteSpace($policyID)) {
                "$Script:DSBaseURI/api/pam/checkout-policies/$policyID"
            }
            else {
                "$Script:DSBaseURI/api/pam/checkout-policies"
            }
            
            $params = @{
                Uri    = $URI
                Method = 'GET'
            }

            Write-Verbose "[Get-DSPamCheckoutPolicies] About to call with $params.Uri..."

            $response = Invoke-DS @params
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
            Write-Verbose '[Get-DSPamCheckoutPolicies] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSPamCheckoutPolicies] ended with errors...'
        }
    }
}