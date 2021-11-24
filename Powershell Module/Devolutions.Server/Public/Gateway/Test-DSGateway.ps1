function Test-DSGateway {
    [CmdletBinding()]
    param (
        [guid]$GatewayId = $(throw 'You must provide the ID of the Devolutions Gateway you want to ping.')
    )
    
    begin {
        Write-Verbose '[Test-DSGateway] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            URI     = "$Script:DSBaseURI/api/gateway/$GatewayId/health"
            Method = 'GET'
        } 
       
        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Test-DSGateway] Completed successfully!') : (Write-Verbose '[Test-DSGateway] Ended with errors...')
    }
}