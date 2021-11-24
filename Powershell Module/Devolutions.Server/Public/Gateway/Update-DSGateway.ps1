function Update-DSGateway {
    [CmdletBinding()]
    param (
        [guid]$GatewayId = $(throw 'You must provide the ID of the Devolutions Gateway you want to update.'),
        [string]$Name,
        [string]$Description,
        [bool]$IsDefault,
        [string]$DevolutionsGatewayUrl,
        [int]$TCPListeningPort,
        [int]$TokenDuration,
        [int]$HealthCheckInterval,
        [bool]$ForceIpAddressForRdpConnections 

    )
    
    begin {
        Write-Verbose '[New-DSGateway] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
        
        $PSBoundParameters.Remove('GatewayId') | Out-Null

        $ParamsDict = @{
            DevolutionsGatewayUrl           = 'apiListener'
            TokenDuration                   = 'expirationMinutes'   
            ForceIpAddressForRdpConnections = 'forceIpAddress'
            HealthCheckInterval             = 'healthCheckIntervalMinutes'
            TCPListeningPort                = 'rdpPort'
        }
    }
    
    process {
        $Gateway = (($res = Get-DSGateway -GatewayId $GatewayId).isSuccess) ? $res.Body.data : $(throw "Could not find a Devolutions Gateway matching the ID $GatewayId")

        foreach ($Param in $PSBoundParameters.GetEnumerator()) {
           ($Param.Key -in $ParamsDict.Keys) ? ($Gateway.($ParamsDict[$Param.Key]) = $Param.Value) : ($Gateway.($Param.Key) = $Param.Value) | Out-Null
        }

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/gateway/$GatewayId"
            Method = 'PUT'
            Body   = (ConvertTo-Json $Gateway)
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        
        $res.isSuccess ? (Write-Verbose '[Remove-DSGateway] Completed successfully!') : (Write-Verbose '[Remove-DSGateway] Ended with errors...')
    }
}