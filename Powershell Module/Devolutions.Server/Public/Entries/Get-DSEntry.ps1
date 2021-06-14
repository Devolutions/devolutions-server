function Get-DSEntry {
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
            [GUID]$EntryId,
            [switch]$IncludeAdvancedProperties
        )
        
    BEGIN {
        Write-Verbose '[Get-DSEntry] Beginning...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        [ServerResponse]$response = Get-DSEntryLegacy @PSBoundParameters
        return $response
    }
    
    END {
        If ($response.isSuccess) {
            Write-Verbose '[Get-DSEntry] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSEntry] ended with errors...'
        }
    }
}