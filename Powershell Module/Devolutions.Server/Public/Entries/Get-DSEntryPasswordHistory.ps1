function Get-DSEntryPasswordHistory {
    <#
        .SYNOPSIS
        Returns the password history for a given entry.
    #>
    [CmdletBinding()]
    param(			
        [ValidateNotNullOrEmpty()]
        [guid]$EntryId
    )
        
    BEGIN {
        Write-Verbose '[Get-DSEntryPasswordHistory] Beginning...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/connections/partial/$EntryId/password-history"
            Method = 'GET' 
        }
        
        $res = Invoke-DS @RequestParams
        $res.Body.data = $res.Body.data | ConvertFrom-Json -Depth 10
        return $res
    }
    
    END {
        If ($res.isSuccess) {
            Write-Verbose '[Get-DSEntryPasswordHistory] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSEntryPasswordHistory] ended with errors...'
        }
    }
}