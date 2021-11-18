function Import-DSAdUsers {
    [CmdletBinding()]
    param (
        [string]$DomainName,
        [parameter(ParameterSetName = 'ImportByName')]
        [string[]]$Names,
        [parameter(ParameterSetName = 'ImportAll')]
        [switch]$All
    )
    
    begin {
        Write-Verbose '[Import-DSAdUsers] Beginning...'
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }
    }
    
    process {
        $DomainUsers = ($res = Get-DSDomainUsers $DomainName).isSuccess ? ($res.Body.data) : $(throw 'Could not load domain users.')

        $ToImport = switch ($PSCmdlet.ParameterSetName) {
            'ImportByName' { ImportAdUsersByName $Names $DomainUsers }
            'ImportAll' { ImportAllAdUsers $DomainUsers }
        }

        if ($ToImport.Count -eq 0) {
            throw 'Could not find any domain users to import.'
        }

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/domains/ad/users/import"
            Method = 'POST'
            Body   = (ConvertTo-Json $ToImport)
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Import-DSAdUsers] Completed successfully!') : (Write-Verbose '[Import-DSAdUsers] Ended with errors...')
    }
}

function ImportAdUsersByName {
    param (
        [string[]]$Names,
        $DomainUsers
    )
    
    return $DomainUsers.GetEnumerator() |
    Where-Object { $Names.Contains($_.samAccountName) } | 
    Select-Object @{N = 'domainName'; E = { $_.domainName } }, 
    @{N = 'sid'; E = { $_.sid } }, 
    @{N = 'userId'; E = { $_.id } }, 
    @{N = 'repositoryId'; E = { 'ffffffff-ffff-ffff-ffff-ffffffffffff' } }, 
    @{N = 'readOnlyUser'; E = { $false } }
}

function ImportAllAdUsers {
    param (
        $DomainUsers
    )

    return $DomainUsers.GetEnumerator() | 
    Select-Object @{N = 'domainName'; E = { $_.domainName } }, 
    @{N = 'sid'; E = { $_.sid } }, 
    @{N = 'userId'; E = { $_.id } }, 
    @{N = 'repositoryId'; E = { 'ffffffff-ffff-ffff-ffff-ffffffffffff' } }, 
    @{N = 'readOnlyUser'; E = { $false } }
}