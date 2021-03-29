function Get-DSPamCheckoutPolicies {
    <#
    .SYNOPSIS
    Returns checkout policy(ies) or checkout policies count.
    .DESCRIPTION
    Using a switch parameter (-Count), it is possible to return the checkout policies current count. If a policy ID is supplied, it will try to return
    that policy. If a policy ID and the switch parameter are both supplied, the checkout policies current count will be returned.
    If neither policy ID nor switch parameter are supplied, it will return all checkout policies.
    .EXAMPLE
    Get-DSPamCheckoutPolicies #Returns all checkout policies currently in place.
    Get-DSPamCheckoutPolicies $policyID #Returns the checkout policy, if found.
    Get-DSPamCheckoutPolicies -Count #Return the number of checkout policies in place.
    Get-DSPamCheckoutPolicies $policyID -Count #Return the number of checkout policies in place.
    #>
    [CmdletBinding()]
    param(
        [string]$policyID,	
        [System.Management.Automation.SwitchParameter]$Count
    )
        
    BEGIN {
        Write-Verbose '[Get-DSPamCheckoutPolicies] Begin...'
    
        $URI = if ($Count) { 
            "$Script:DSBaseURI/api/pam/checkout-policies/count"
        } 
        else { 
            if (![string]::IsNullOrWhiteSpace($policyID)) {
                "$Script:DSBaseURI/api/pam/checkout-policies/$policyID"
            }
            else {
                "$Script:DSBaseURI/api/pam/checkout-policies"
            }
            
        }
        
        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {   	
            $params = @{
                Uri    = $URI
                Method = 'GET'
            }

            Write-Verbose "[Get-DSPamCheckoutPolicies] About to call with $params.Uri..."

            $response = Invoke-DS @params

            if ($response.isSuccess) { 
                Write-Verbose "[Get-DSPamCheckoutPolicies] Operation was successful."
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
            Write-Verbose '[Get-DSPamCheckoutPolicies] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSPamCheckoutPolicies] ended with errors...'
        }
    }
}