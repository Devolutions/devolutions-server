function New-DSPamProvider {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    This is the first iteration of this implementation.  We are trying a few approaches to better hide the 
    complexity inherent with our backend.  The username should NOT be mandatory
    .LINK
    #>
    [CmdletBinding()]
    param(
        [guid]$ID,
        [ValidateNotNullOrEmpty()]
        [string]$name,
        [ValidateSet('LocalUser', 'DomainUser', 'SqlServer')]
        [string]$credentialType,
        [ValidateNotNullOrEmpty()]
        [string]$username
    )
        
    BEGIN {
        Write-Verbose '[New-DSPamProvider] Begin...'
    
        $URI = "$Script:DSBaseURI/api/pam/providers"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $credentialTypeValue = switch ( $credentialType ) {
                'LocalUser' { 2; break }
                'DomainUser' { 3; break }
                'SqlServer' { 5; break }
            }

            $newProviderData = @{
                ProviderID        = $ID
                label             = $name
                CredentialType    = $credentialTypeValue
                Username          = $username
                #TODO handle the enum
                ProtectedDataType = 1
            }
            
            $params = @{
                Uri    = $URI
                Method = 'POST'
                Body   = $newProviderData | ConvertTo-Json
            }

            Write-Verbose "[New-DSPamProvider] About to call with ${params.Uri}"

            $response = Invoke-DS @params
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
        If ($response.isSuccess) {
            Write-Verbose '[New-DSPamProviders] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamProviders] Ended with errors...'
        }
    }
}