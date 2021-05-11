function Remove-DSEntry {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .NOTES
    #>
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$CandidEntryID
    )

    BEGIN {
        Write-Verbose "[Remove-DSEntry] Beginning..." 
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $URI = "$Script:DSBaseURI/api/connections/partial/$CandidEntryID"

            $Params = @{
                URI    = $URI
                Method = "DELETE"
            }

            $res = Invoke-DS @Params
            return $res
        }
        catch {
            $Exception = $_.Exception
            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Exception] $Exception"
            } 
        }
    }

    END {
        if ($res.isSucess -and !$?) {
            Write-Verbose "[Remove-DSEntry] Completed successfully!" 
        }
        else {
            Write-Verbose "[Remove-DSEntry] Ended with errors..." 
        }
    }
}