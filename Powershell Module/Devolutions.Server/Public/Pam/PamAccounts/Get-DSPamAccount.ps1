function Get-DSPamAccount {
    <#
    .SYNOPSIS
    Fetch a PAM account

    .EXAMPLE
    > $PamAccount = (Get-DSPamAccount $PamAccountId).Body
    #>
    
    [CmdletBinding()]
    param (
        [guid]$accountId
    )
    
    begin {
        Write-Verbose '[New-DSPamAccount] Beginning...'
        $URI = "$Script:DSBaseURI/api/pam/credentials"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }
    }
    
    process {
        $params = @{
            Uri    = "$URI/$accountId"
            Method = 'GET'
        }

        $res = Invoke-DS @params
        return $res 
    }
    
    end {
        Write-Verbose ($res.isSuccess ? '[Get-DSPamAccount] Completed Successfully.' : '[Get-DSPamAccount] Ended with errors...')
    }
}