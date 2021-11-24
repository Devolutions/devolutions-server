function Remove-DSGateway {
    [CmdletBinding()]
    param (
        [guid]$GatewayId = $(throw 'You must provide the ID of the Devolutions Gateway you want to delete.')
    )
    
    begin {
        Write-Verbose '[Remove-DSGateway] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            URI    = "$Script:DSBaseUri/gateway/$GatewayId"
            Method = 'DELETE'
        } 

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Remove-DSGateway] Completed successfully!') : (Write-Verbose '[Remove-DSGateway] Ended with errors...')
    }
}