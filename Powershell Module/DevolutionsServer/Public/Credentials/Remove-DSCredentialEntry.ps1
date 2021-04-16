function Remove-DSCredentialEntry {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [guid]$CandidEntryID
    )
        
    BEGIN {
        Write-Verbose '[New-DSCredentialEntry] begin...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $URI = "$Script:DSBaseURI/api/connections/partial/$CandidEntryID"
  
            $params = @{
                Uri    = $URI
                Method = 'DELETE'
            }
    
            $res = Invoke-DS @params
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }

    END {
        if ($? -and $res.isSuccess) {
            Write-Verbose '[New-DSCredentialEntry] Completed successfully.'
        }
        else {
            Write-Verbose '[New-DSCredentialEntry] Ended with errors...'
        }
    }
}