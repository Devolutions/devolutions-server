function New-DSPamCheckoutPolicy {
    <#
    .SYNOPSIS
    Creates a new PAM checkout policy.
    .DESCRIPTION
    Creates a new PAM checkout policy using supplied parameters. If one or more parameters are ommited, they default to a certain value.
    Only mandatory value is "name".
    .EXAMPLE
    $newPolicy = @{
        name = "public accounts"
        checkoutTime = 120
        isDefault = $true
    }

    > New-DSPamCheckoutPolicy @newPolicy
    #>
    [CmdletBinding()]
    param(
        #Policy's new name
        [ValidateNotNullOrEmpty()]
        [string]$name = $(throw 'Name is null or empty. Please provide a name and try again.'),
        #Used to select approval mode (None/Mandatory)
        [int]$checkoutApprovalMode,
        #Used to select checkout reason mode (None/Mandatory/Optional)
        [int]$checkoutReasonMode,
        #Used to select if owner can self-checkout
        [int]$allowCheckoutOwnerAsApprover,
        #Used to select if administrators can approve checkout
        [int]$includeAdminsAsApprovers,
        #Used to select if PAM managers can approve checkout
        [int]$includeManagersAsApprovers,
        #Used to select default checkout time
        [int]$checkoutTime,
        #Used to set default policy
        [bool]$isDefault
    )
        
    BEGIN {
        Write-Verbose '[New-DSPamCheckoutPolicy] Beginning...'
        
        $URI = "$Script:DSBaseURI/api/pam/checkout-policies"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        try {
            $isNameUsed = $false

            #1. Check all policies for matching name
            if ((Get-DSPamCheckoutPolicies -Count).Body -gt 0) {
                $checkoutPoliciesList = (Get-DSPamCheckoutPolicies).Body
                
                $checkoutPoliciesList | ForEach-Object {
                    if ($_.name -eq $name) {
                        $isNameUsed = $true
                    }
                }
            }

            #2. If name not found, proceed with creation
            if ($isNameUsed -eq $true) {
                return [ServerResponse]::new($false, $null, $null, $null, 'Checkout policy with same name already exists. Please try again with another name.', 409)
            }
            else {
                $newCheckoutPolicyData = @{
                    name = $name
                }

                $PSBoundParameters.GetEnumerator() | ForEach-Object {
                    $isValid = $true

                    switch ($_) {
                        { $_.Key -eq 'name' } {}
                        ($_.Key -eq 'checkoutApprovalMode') { 
                            if ($_.Value -notin { 0, 1, 2 }) { $isValid = $false }
                        } 
                        { $_.Key -eq 'checkoutReasonMode' } { 
                            if ($_.Value -notin { 0, 1, 2, 3 }) { $isValid = $false }
                        } 
                        { $_.Key -eq 'allowCheckoutOwnerAsApprover' } { 
                            if ($_.Value -notin { 0, 1, 2 }) { $isValid = $false }
                        }   
                        { $_.Key -eq 'includeAdminsAsApprovers' } { 
                            if ($_.Value -notin { 0, 1, 2 }) { $isValid = $false }
                        }   
                        { $_.Key -eq 'includeManagersAsApprovers' } { 
                            if ($_.Value -notin { 0, 1, 2 }) { $isValid = $false }
                        }  
                        default { $isValid = $false }
                    }
    
                    if ($isValid) { $newCheckoutPolicyData[$_.Key] = $_.Value }
                }
            }

            $params = @{
                Uri    = $URI
                Method = 'POST'
                Body   = $newCheckoutPolicyData | ConvertTo-Json
            }

            $res = Invoke-DS @params
            return $res
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
    }
    
    END {
        If ($res.isSuccess) {
            Write-Verbose '[New-DSPamCheckoutPolicy] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamCheckoutPolicy] ended with errors...'
        }
    }
}