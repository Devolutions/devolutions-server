function Remove-DSAdDomain {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty]
        [guid]$DomainId
    )
    
    begin {
        Write-Verbose '[New-DSAdDomain] Beginning...'
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            URI    = "$Script:DSBaseUri/api/active-directory/domain-configurations/$DomainId"
            Method = 'DELETE'
        }
        
        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[New-DSAdDomain] Completed successfully!') : (Write-Verbose '[New-DSAdDomain] Ended with errors...')
    }
}