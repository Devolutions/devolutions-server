function Remove-DSVault {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .EXAMPLE
    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$VaultID = $(throw "Vault ID is null or empty. Please provide a valid vault ID for deletion.")
    )
    
    BEGIN {
        Write-Verbose "[New-DSVault] Begining..."

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $RequestParams = @{
                URI    = "$env:DS_URL/api/security/repositories/$VaultID"
                Method = "DELETE"
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
            Write-Verbose "[New-DSVault] Completed successfully!"
        }
        else {
            Write-Verbose "[New-DSVault] Ended with errors..."
        }
    }
}