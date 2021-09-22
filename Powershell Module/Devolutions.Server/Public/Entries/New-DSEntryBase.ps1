function New-DSEntryBase {
    <#
        .SYNOPSIS
        Creates a new entry
        .DESCRIPTION
        Creates a new entry without validating anything. This is the functional equivalent of a passthrough.
        .NOTES
        Unless you know exactly what you are doing, you should probably use the CMDlets created by us to generate new entries.
    #>
    [CmdletBinding()]
    PARAM (
        $Body
    )

    BEGIN {
        Write-Verbose '[New-DSEntryBase] Beginning...'

        $URI = "$Script:DSBaseURI/api/connections/partial/save"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }

    PROCESS {
        try {
            $RequestParams = @{
                URI    = $URI
                Method = "POST"
                Body   = $Body | ConvertTo-Json -Depth 100
            }

            $res = Invoke-DS @RequestParams -Verbose
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }

    END {
        if ($res.isSuccess) {
            Write-Verbose "[New-DSEntryBase] Completed successfully!"
        }
        else {
            Write-Verbose "[New-DSEntryBase] Ended with errors..."
        }
    } 
}