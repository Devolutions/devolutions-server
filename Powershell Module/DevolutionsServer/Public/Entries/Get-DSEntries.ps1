function Get-DSEntries {
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
        [guid]$VaultId
    )
        
    BEGIN {
        Write-Verbose '[Get-DSEntries] begin...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        [ServerResponse]$response = Get-DSEntriesLegacy @PSBoundParameters
        return $response
    }
    
    END {
        If ($response.isSuccess) {
            Write-Verbose '[Get-DSEntries] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSEntries] ended with errors...'
        }
    }
}