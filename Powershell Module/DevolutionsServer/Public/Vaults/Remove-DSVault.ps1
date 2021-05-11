function Remove-DSVault {
    <#
        .SYNOPSIS
        Deletes a vault.
        .DESCRIPTION
        Deletes a vault from DVLS instance and delete all entries inside of it. Be careful, this action is irreversible if you don't have a recent back-up.
    #>
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        #Vault's ID to delete
        [guid]$VaultID = $(throw "Vault ID is null or empty. Please provide a valid vault ID for deletion.")
    )
    
    BEGIN {
        Write-Verbose "[New-DSVault] Beginning..."

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $RequestParams = @{
                URI    = "$Script:DSBaseURI/api/security/repositories/$VaultID"
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