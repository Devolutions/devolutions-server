function Get-DSPamAccountSyncStatus {
    <#
    .SYNOPSIS
    Fetch the synchronization status for a given PAM account

    .EXAMPLE
    > $SyncStatus = (Get-DSPamAccountSyncStatus $PamAccountId).Body
    #>
    
    [CmdletBinding()]
    param (
        [guid]$PamAccountId
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
            Uri    = "$URI/$PamAccountId/ping"
            Method = 'GET'
        }

        $res = Invoke-DS @params
        return $res
    }
    
    end {
        Write-Verbose ($res.isSuccess ? '[Get-DSPamAccountSyncStatus] Completed Successfully.' : '[Get-DSPamAccountSyncStatus] Ended with errors...')
    }
}