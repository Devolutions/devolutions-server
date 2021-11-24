function New-DSGateway {
    [CmdletBinding()]
    param (
        [string]$Name = $(throw 'You must provide a name for the Devolutions Gateway.'),
        [string]$Description,
        [bool]$IsDefault = $false,
        [string]$DevolutionsGatewayUrl = $(throw 'You must provide a URL for the Devolutions Gateway.'),
        [int]$TCPListeningPort = $(throw 'You must provide a TCP listening port for the Devolutions Gateway.'),
        [int]$TokenDuration = 5,
        [int]$HealthCheckInterval = 60,
        [bool]$ForceIpAddressForRdpConnections = $false
    )
    
    begin {
        Write-Verbose '[New-DSGateway] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $Gateway = @{
            apiListener                = $DevolutionsGatewayUrl
            description                = $Description
            expirationMinutes          = $TokenDuration
            forceIpAddress             = $ForceIpAddressForRdpConnections
            health                     = @{}
            healthCheckIntervalMinutes = $HealthCheckInterval
            isDefault                  = $IsDefault
            name                       = $Name
            rdpPort                    = $TCPListeningPort
        }

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/gateway"
            Method = 'POST'
            Body   = (ConvertTo-Json $Gateway)
        } 

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[New-DSGateway] Completed successfully!') : (Write-Verbose '[New-DSGateway] Ended with errors...')
    }
}