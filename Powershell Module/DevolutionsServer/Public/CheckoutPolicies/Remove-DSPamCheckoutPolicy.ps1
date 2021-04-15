function Remove-DSPamCheckoutPolicy {
    <#
    .SYNOPSIS
    Delete a checkout policy
    .DESCRIPTION
    Delete a checkout policy if it exists. If not, throws an error indicating that the policy was not found.
    .EXAMPLE
    Remove-DSPamCheckoutPolicy -policyID "ad375b93-9fb7-4f37-a8c7-e20bf382f68d"
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [guid]$candidPolicyID
    )

    BEGIN {
        Write-Verbose '[Remove-DSPamCheckoutPolicy] Begining...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    PROCESS {
        $URI = "$Script:DSBaseURI/api/pam/checkout-policies/$candidPolicyID"

        $params = @{
            Uri    = $URI
            Method = 'DELETE'
        }

        $res = Invoke-DS @params
        return $res
    }
    END {
        If ($res.isSuccess) {
            Write-Verbose '[Remove-DSPamCheckoutPolicy] Completed Successfully.'
        }
        else {
            Write-Verbose '[Remove-DSPamCheckoutPolicy] Ended with errors...'
        }
    }
}