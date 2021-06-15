function Get-DSFolder {
    <#
        .SYNOPSIS
        Returns a folder by ID.
        .DESCRIPTION
        Returns a folder by ID, with possibility of including advanced folder properties
        .EXAMPLE
        > Get-DSFolder -FolderId "Your [guid] here"

        .EXAMPLE
        > Get-DSFolder -FolderId "Your [guid] here" -IncludeAdvancedProperties
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [Guid]$FolderId,
        #Used to select if advanced properties should be included
        [switch]$IncludeAdvancedProperties
    )
        
    BEGIN {
        Write-Verbose '[Get-DSFolder] Beginning...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        [ServerResponse]$response = Get-DSEntryLegacy @PSBoundParameters
        return $response
    }
    
    END {
        If ($response.isSuccess) {
            Write-Verbose '[Get-DSFolder] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSFolder] ended with errors...'
        }
    }
}