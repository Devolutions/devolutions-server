function Get-DSGatewayLogs {
    [CmdletBinding()]
    param (
        [guid]$GatewayId = $(throw 'You must provide the ID of the Devolutions Gateway you want to ping.'),
        [string]$OutputPath = $(throw 'You must provide an output path for the log file.')
    )
    
    begin {
        Write-Verbose '[Get-DSGatewayLogs] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            ContentType = 'text/plain; charset=utf-8'
            URI         = "$Script:DSBaseURI/api/gateway/$GatewayId/diagnostics/logs"
            Method      = 'GET'
            WebSession  = $Global:WebSession
        } 
       
        $res = Invoke-WebRequest @RequestParams

        ($res.Content | Test-Json) -eq $false ? ($res.Content | Out-File -FilePath $OutputPath) : $(throw 'Could not fetch logs for your Devolutions Gateway.')

        [ServerResponse]$newResponse = [ServerResponse]::new($true, $res, $res.Content, $null, '', 200)

        return $newResponse
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Get-DSGatewayLogs] Completed successfully!') : (Write-Verbose '[Get-DSGatewayLogs] Ended with errors...')
    }
}