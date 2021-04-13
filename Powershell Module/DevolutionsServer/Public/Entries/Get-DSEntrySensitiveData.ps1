function Get-DSEntrySensitiveData {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    Only works for DVLS 2020.3.17 and later.
    #>
    [CmdletBinding()]
    param(			
        [ValidateNotNullOrEmpty()]
        [guid]$EntryId    
    )
 
    BEGIN {
        Write-Verbose '[Get-DSEntrySensitiveData] begin...'
        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }

        if ([string]::IsNullOrWhiteSpace($Script:DSInstanceVersion)) {
            throw "Your Devoltions Server version is not supported by this module. Please update to the latest stable release."
        }
    }
    
    PROCESS {
        [ServerResponse]$response = Get-DSEntrySensitiveDataLegacy @PSBoundParameters
        return $response
    }
    
    END {
        If ($response.isSuccess) {
            Write-Verbose '[Get-DSEntrySensitiveData] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSEntrySensitiveData] ended with errors...'
        }
    }
}