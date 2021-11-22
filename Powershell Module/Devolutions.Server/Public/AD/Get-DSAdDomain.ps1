function Get-DSAdDomain {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'All')]
        [switch]$All 
    )
    
    begin {
        Write-Verbose '[New-DSAdDomain] Beginning...'
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/active-directory/domain-configurations"
            Method = 'GET'
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[New-DSAdDomain] Completed successfully!') : (Write-Verbose '[New-DSAdDomain] Ended with errors...')
    }
}