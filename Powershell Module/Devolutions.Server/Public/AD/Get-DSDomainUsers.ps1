function Get-DSDomainUsers {
    [CmdletBinding()]
    param (
        [string]$DomainName
    )
    
    begin {
        Write-Verbose '[Import-DSAdUser] Beginning...'
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            URI = "$Script:DSBaseURI/api/domains/ad/users?domainNames=$DomainName"
            Method = 'GET'
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Import-DSAdUser] Completed successfully!') : (Write-Verbose '[Import-DSAdUser] Ended with errors...')
    }
}