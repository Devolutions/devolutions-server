function Update-DSEntryBase {
    [CmdletBinding()]
    PARAM (
        $jsonBody
    )
    BEGIN {
        Write-Verbose "[Update-DSEntryBase] Beginning..."

        $URI = "$env:DS_URL/api/connections/partial/save"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }

    PROCESS {
        try {
            $EntryCtx = Get-DSEntry $CandidEntryID -IncludeAdvancedProperties

            if (!$EntryCtx.isSuccess) {
                throw [System.Management.Automation.ItemNotFoundException]::new("Provided entry couldn't be found. Make sure you are using a valid entry ID.")
            }

            $RequestParams = @{
                Uri    =  $URI
                Method = "PUT"
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
            Write-Verbose "[Update-DSEntryBase] Completed successfully!"
        }
        else {
            Write-Verbose "[Update-DSEntryBase] Ended with errors..."
        }
    }
}