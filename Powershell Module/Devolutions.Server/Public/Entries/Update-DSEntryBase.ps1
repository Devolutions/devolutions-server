function Update-DSEntryBase {
    <#
        .SYNOPSIS
        Updates an entry.
        .DESCRIPTION
        Updates a given entry (Modified entry should be in jsonBody).
        .NOTES
        Serves as a passthrough for people who might need one. This should not be called independently. Please see Update-DS*EntryType* instead.
    #>
    [CmdletBinding()]
    PARAM (
        $jsonBody
    )
    BEGIN {
        Write-Verbose '[Update-DSEntryBase] Beginning...'

        $URI = "$Script:DSBaseURI/api/connections/partial/save"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }

    PROCESS {
        try {
            $RequestParams = @{
                Uri    = $URI
                Method = 'PUT'
                Body   = $jsonBody
            }

            $res = Invoke-DS @RequestParams
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }

    END {
        if ($? -and $res.isSuccess) {
            Write-Verbose '[Update-DSEntryBase] Completed successfully!'
        }
        else {
            Write-Verbose '[Update-DSEntryBase] Ended with errors...'
        }
    }
}