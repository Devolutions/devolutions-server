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

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            [int] $credentialTypeValue
            switch ( $credentialType ) {
                'LocalUser' {
                    $credentialTypeValue = 2
                }
                'DomainUser' {
                    $credentialTypeValue = 3
                }
                'SqlServer' {
                    $credentialTypeValue = 5
                }
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

            if ($response.isSuccess) { 
                Write-Verbose "[New-DSPamProviders] Provider creation was successful"
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
            Write-Verbose '[New-DSPamProviders] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamProviders] Ended with errors...'
        }
    }
}