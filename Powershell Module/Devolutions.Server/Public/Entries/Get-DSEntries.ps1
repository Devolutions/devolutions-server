function Get-DSEntries {
    <#
        .SYNOPSIS
        Returns all entries of a given vault.
        .EXAMPLE
        > Get-DSEntries -VaultId "[guid]"

    #>
    [CmdletBinding()]
    param(			
        [ValidateNotNullOrEmpty()]
        [guid]$VaultId
    )
        
    BEGIN {
        Write-Verbose '[Get-DSEntries] Beginning...'
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