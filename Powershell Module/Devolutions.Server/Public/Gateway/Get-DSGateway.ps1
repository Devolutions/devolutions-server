function Get-DSGateway {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [parameter(ParameterSetName = 'ById')]
        [guid]$GatewayId,
        [parameter(ParameterSetName = 'ByName')]
        [string]$Name,
        [parameter(ParameterSetName = 'All')]
        [switch]$All        
    )
    
    begin {
        Write-Verbose '[Get-DSGateway] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/gateway"
            Method = 'GET'
        }

        $res = Invoke-DS @RequestParams

        if (!$res.isSuccess) {
            throw 'Could not fetch your Devolutions Gateways'
        }

        switch ($PSCmdlet.ParameterSetName) {
            'ById' {
                $Gateway = $res.Body.data | Where-Object { $_.id -eq $GatewayId }
                $res.Body.data = $Gateway ?? $(throw "Could not find a Devolutions Gateway matching the ID $GatewayId")
            }
            'ByName' { 
                $Gateway = $res.Body.data | Where-Object { $_.name -eq $Name } 
                $res.Body.data = $Gateway ?? $(throw "Could not find a Devolutions Gateway matching the name $Name")
            }
        }

        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Get-DSGateway] Completed successfully!') : (Write-Verbose '[Get-DSGateway] Ended with errors...')
    }
}
