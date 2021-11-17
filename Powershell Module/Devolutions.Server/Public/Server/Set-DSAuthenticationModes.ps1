function Set-DSAuthenticationModes {
    [CmdletBinding()]
    param (
        [bool]$AzureADAuthenticationEnabled,
        [bool]$CustomAuthenticationEnabled,
        [bool]$DomainAuthenticationEnabled
    )
    
    begin {
        Write-Verbose '[Set-DSAuthenticationModes] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }

        if ($PSBoundParameters.Count -eq 0) {
            throw 'No parameter were set. Authentication modes have not been changed.'
        }
    }
    
    process {
        $AuthModes = ($res = Get-DSAuthenticationModes).isSuccess ? ($res.Body.data) : $(throw 'Could not fetch your current authentication modes.')

        if ($PSBoundParameters.ContainsKey('AzureADAuthenticationEnabled')) {
            $AuthModes | Add-Member -NotePropertyName 'azureADAuthenticationEnabled' -NotePropertyValue $AzureADAuthenticationEnabled -Force
        }
        
        if ($PSBoundParameters.ContainsKey('CustomAuthenticationEnabled')) {
            $AuthModes | Add-Member -NotePropertyName 'customAuthenticationEnabled' -NotePropertyValue $CustomAuthenticationEnabled -Force
        }

        if ($PSBoundParameters.ContainsKey('DomainAuthenticationEnabled')) {
            $AuthModes | Add-Member -NotePropertyName 'domainAuthenticationEnabled' -NotePropertyValue $DomainAuthenticationEnabled -Force
        }
        
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/configuration/authentication"
            Method = 'PUT'
            Body   = (ConvertTo-Json $AuthModes)
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Set-DSAuthenticationModes] Completed successfully!') : (Write-Verbose '[Set-DSAuthenticationModes] Ended with errors...')
    }
}