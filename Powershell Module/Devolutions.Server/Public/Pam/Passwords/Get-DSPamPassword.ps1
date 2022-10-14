function Get-DSPamPassword {
    <#
        .SYNOPSIS
        Returns the PAM credential password.
        .DESCRIPTION
        Retrurns the PAM credential password if it is currently checked out and user has rights. By default,
        password stays encrypted. The 'Decrypted' flag need to be present in order to see the password
        in clear text.
        .EXAMPLE
        Please check the sample script provided with the module.
    #>
    [CmdletBinding()]
    PARAM (
        [guid]$PamCredentialID
    )
    
    BEGIN {
        Write-Verbose '[Get-DSPamPassword] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/pam/passwords/$PamCredentialID"
            Method = 'GET'
        }

        try {
            $res = Invoke-DS @RequestParams
            return $res
        }
        catch { throw $_.ErrorDetails }
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Get-DSPamPassword] Completed successfully!') : (Write-Verbose '[Get-DSPamPassword] Ended with errors...')
    }
}