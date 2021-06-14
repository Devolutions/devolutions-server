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
        [ValidateNotNullOrEmpty()]
        [guid]$ProviderID
    )
        
    BEGIN {
        Write-Verbose '[Remove-DSPamProvider] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        $URI = "$Script:DSBaseURI/api/pam/providers/$ProviderID"

        try {
            $params = @{
                Uri    = $URI
                Method = 'DELETE'
            }

            Write-Verbose "[Remove-DSPamProvider] About to call with ${params.Uri}"

            $res = Invoke-DS @params -Verbose
            return $res
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::Break -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
    }
    
    END {
        If ($res.isSuccess) {
            Write-Verbose '[Remove-DSPamProviders] Completed Successfully.'
        }
        else {
            Write-Verbose '[Remove-DSPamProviders] Ended with errors...'
        }
    }
}