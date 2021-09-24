function Get-DSEntrySubConnections {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [guid]$EntryID
    )
    
    begin {
        Write-Verbose '[Get-DSEntrySensitiveData] Beginning...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $RequestParams = @{
            URI = "$($Script:DSBaseURI)/api/connections/partial/$($EntryID)/sub-connections"
            Method = 'GET'
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.IsSuccess ? (Write-Verbose '[Get-DSEntrySubConnections] Completed successfully!') : (Write-Verbose '[Get-DSEntrySubConnections] Ended with errors...')
    }
}