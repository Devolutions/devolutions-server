function Get-DSServerInfo {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$URL = $(throw 'You must provide a URL to a valid DVLS instance before calling Get-DSServerInfo.')
    )
    
    begin {
        Write-Verbose '[Get-DSServerInfo] Beginning...'
    }
    
    process {
        $RequestParams = @{
            URI    = "$URL/api/server-information"
            Method = 'GET'
        }

        try {
            $res = Invoke-DS @RequestParams -Verbose

            if (!$res.isSuccess) {
                throw "[Get-DSServerInfo] Error while contacting your DVLS instance. Make sure your URL points to a valid DVLS instance."
            }

            $IsDVLSInstance = @(Compare-Object $res.Body.PSObject.Properties.Name @('data', 'result')).Length -eq 0
            if (!$IsDVLSInstance) {
                throw '[Get-DSServerInfo] Could not validate that URL is a valid DVLS instance.'
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }

        return $res
    }
    
    end {
        if ($res.isSuccess) {
            Write-Verbose "[Get-DSServerInfo] Completed successfully!"
        }
        else {
            Write-Verbose "[Get-DSServerInfo] Ended with errors..."
        }
    }
}