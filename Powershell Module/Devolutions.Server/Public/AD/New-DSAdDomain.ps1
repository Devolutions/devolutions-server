function New-DSAdDomain {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()][string]$DomainName,
        [ValidateNotNullOrEmpty()][string]$DisplayName,
        [ValidateNotNullOrEmpty()][string]$AdministrationUsername,
        [ValidateNotNullOrEmpty()][string]$AdministrationPassword,

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
        $MsDomainConfiguration = [MsDomainConfiguration]::new()

        $MsDomainConfiguration.DomainName = $DomainName
        $MsDomainConfiguration.DisplayName = $DisplayName
        $MsDomainConfiguration.AdministrationUsername.Set($AdministrationUsername)
        $MsDomainConfiguration.AdministrationPassword.Set($AdministrationPassword)

        if ($PSBoundParameters.ContainsKey('IsLdaps')) {
            $MsDomainConfiguration.IsLdaps.Set($IsLDAPS)

            $PSBoundParameters.ContainsKey('LdapsCustomPort') ? $MsDomainConfiguration.LdapsCustomPort.Set($LdapsCustomPort) : [void]
        }

        if ($PSBoundParameters.ContainsKey('AutoCreateEnabled') -and $AutoCreateEnabled) {
            $MsDomainConfiguration.AutoCreateEnabled.Set($AutoCreateEnabled)

            if ($PSBoundParameters.ContainsKey('DefaultVault')) {
                $VaultId = ($res = Get-DSVault -All).isSuccess ? 
                    ($res.Body.data | Where-Object { $_.Name -eq $DefaultVault } | Select-Object -ExpandProperty id) : 
                    ([guid]::Empty())

                if ($VaultId -eq ([guid]::Empty)) {
                    Write-Verbose "[New-DSAdDomain] $DefaultVault could not be found. Devolutions Server's default vault used instead."
                }

                $MsDomainConfiguration.AutoCreateVault.Set($VaultId)
            }
            
            $PSBoundParameters.ContainsKey('DomainUsernameFormatType') ? $MsDomainConfiguration.AutoCreateUsernameFormatType.Set($DomainUsernameFormatType) : ([void] | Out-Null)
            $PSBoundParameters.ContainsKey('DomainUserReadOnly') ? $MsDomainConfiguration.AutoCreateReadOnly.Set($DomainUserReadOnly) : ([void] | Out-Null)
        }

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/active-directory/domain-configurations"
            Method = 'POST'
            Body   = (ConvertTo-Json $MsDomainConfiguration)
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[New-DSAdDomain] Completed successfully!') : (Write-Verbose '[New-DSAdDomain] Ended with errors...')
    }
}