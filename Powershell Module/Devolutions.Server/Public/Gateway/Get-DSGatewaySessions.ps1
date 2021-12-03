function Get-DSGatewaySessions {
    [CmdletBinding()]
    param (
        [guid]$GatewayId = $(throw 'You must provide the ID for the Devolutions Gateway')
    )
    
    begin {
        Write-Verbose '[New-DSGateway] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
       $RequestParams = @{
           URI = "$Script:DSBaseURI/api/gateway/$GatewayId/sessions"
           Method = 'GET'
       } 

       $res = Invoke-DS @RequestParams
       return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[New-DSGateway] Completed successfully!') : (Write-Verbose '[New-DSGateway] Ended with errors...')
    }
}