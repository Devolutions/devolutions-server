function New-DSAdDomain {
    [CmdletBinding()]
    param (
        [string]$DomainName,
        [string]$DisplayName,
        [string]$AdministrationUsername,
        [string]$AdministrationPassword,

        [bool]$IsLDAPS,
        [int]$LdapsCustomPort,

        [bool]$AutoCreateEnabled = $false,
        [DomainUsernameFormatType]$AutoCreateUsernameFormatType,
        [bool]$AutoCreateReadOnly,
        [string]$AutoCreateVault

    )
    
    begin {
        Write-Verbose '[New-DSAdDomain] Beginning...'
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    
    process {
        $MsDomainConfiguration = [MsDomainConfiguration]::new()
        $MsDomainConfiguration.DomainName = $DomainName
        $MsDomainConfiguration.DisplayName = $DisplayName
        $MsDomainConfiguration.AdministrationUsername.Set($AdministrationUsername)
        $MsDomainConfiguration.AdministrationPassword.Set((Protect-ResourceToHexString $AdministrationPassword))

        $RequestParams = @{
            URI = "$Script:DSBaseURI/api/active-directory/domain-configurations"
            Method = 'POST'
            Body = (ConvertTo-Json $MsDomainConfiguration)
        }

        $res = Invoke-DS @RequestParams
        $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[New-DSAdDomain] Completed successfully!') : (Write-Verbose '[New-DSAdDomain] Ended with errors...')
    }
}