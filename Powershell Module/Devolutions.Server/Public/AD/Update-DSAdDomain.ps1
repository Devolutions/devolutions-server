function Update-DSAdDomain {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [string]$DomainName,
        [string]$DisplayName,
        [string]$AdministrationUsername,
        [string]$AdministrationPassword,

        [bool]$IsLDAPS,
        [int]$LdapsCustomPort,

        [bool]$AutoCreateEnabled = $false,
        [DomainUsernameFormatType]$DomainUsernameFormatType,
        [bool]$DomainUserReadOnly,
        [string]$DefaultVault

    )
    
    begin {
        Write-Verbose '[New-DSAdDomain] Beginning...'
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }
    }
    
    process {    
        $Domain = ($res = Get-DSAdDomain).IsSuccess ? 
            ($res.Body.data | Where-Object { $_.id -eq $DomainId }) :
            ($(throw 'Could not fetch domains from Devolutions Server.'))

        if ($null -eq $Domain) {
            throw 'Could not find specified domain. Make sure the ID exists and try again.' 
        }

        foreach ($Param in $PSBoundParameters.GetEnumerator()) {
            switch ($Param.Key) {
                'DisplayName' { $Domain.DisplayName = $Param.Value }
                'DomainName' { $Domain.DomainName = $Param.Value }
                'AdministrationPassword' { $Domain | Add-Member -NotePropertyName AdministrationPassword -NotePropertyValue (@{value = (Protect-ResourceToHexString $AdministrationPassword) }) }            
                Default { $Domain | Add-Member -NotePropertyName ($Param.Key) -NotePropertyValue (@{value = $Param.Value }) -Force }
            }
        }

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/active-directory/domain-configurations/$DomainId" 
            Method = 'PUT'
            Body   = (ConvertTo-Json $Domain)
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[New-DSAdDomain] Completed successfully!') : (Write-Verbose '[New-DSAdDomain] Ended with errors...')
    }
}