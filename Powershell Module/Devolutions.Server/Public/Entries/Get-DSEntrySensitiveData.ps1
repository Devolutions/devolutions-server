function Get-DSEntrySensitiveData {
    <#
        .SYNOPSIS
        Returns sensitive data for specified entry.
        .EXAMPLE
        > Get-DSEntrySensitiveData -EntryId "[guid]"

        .NOTES
        Supported DVLS versions: >2020.3.17
    #>
    [CmdletBinding()]
    param(			
        [ValidateNotNullOrEmpty()]
        [guid]$EntryId    
    )
 
    BEGIN {
        Write-Verbose '[Get-DSEntrySensitiveData] Beginning...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        try {        
            #if (($LegacyRequested) -or (Confirm-DSServerVersionAtLeast -CandidVersion "2020.3.17")) {
            if (Confirm-DSServerVersionAtLeast -CandidVersion '2020.3.17') {
                [ServerResponse]$response = Get-DSEntrySensitiveDataLegacy @PSBoundParameters
            }
            else {
                #TODO Get-DSEntrySensitiveDataModern ?
                throw [System.Exception]::new("Retreiving entries's sensitive data is supported only for DVLS v2020.3.17 and later. Please consider updating your DVLS instance.")
            }

            return $response
        }
        catch {
            $Exception = $_.Exception
            Write-Error $Exception.Message
        }
    }
    
    END {
        If ($? -and $response.isSuccess) {
            Write-Verbose '[Get-DSEntrySensitiveData] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSEntrySensitiveData] Ended with errors...'
        }
    }
}