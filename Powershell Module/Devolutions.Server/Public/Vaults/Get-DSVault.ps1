function Get-DSVault {
    <#
    .SYNOPSIS
    Gets a specific vault or a collection of vaults.
    .DESCRIPTION
    By default, it will return a vault with the ID matching the one you provided. If you use the -All parameter, it will
    fetch all vaults in your Devolutions Server Instance.
    .EXAMPLE

    .EXAMPLE
    #>
    [CmdletBinding()]
    param(			
        [guid]$VaultID,
        [switch]$All
    )
        
        BEGIN {
            Write-Verbose '[Get-DSVault] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $URI = if ($All) {
            "$Script:DSBaseURI/api/security/vaults" 
        }
        else { 
            if ($null -eq $VaultID) {
                throw 'Please provide a valid vault ID or use the "All" parameter.'
            }
            "$Script:DSBaseURI/api/security/vaults/$VaultID" 
        }

        try {   	
            $params = @{
                Uri    = $URI
                Method = 'GET'
            }

            Write-Verbose "[Get-DSVault] about to call with $($params.Uri)"

            [ServerResponse] $response = Invoke-DS @params

            if ($response.isSuccess) { 
                Write-Verbose "[Get-DSVault] Got $($response.Body.data)"
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
            Write-Verbose '[Get-DSVault] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSVault] ended with errors...'
        }
    }
}