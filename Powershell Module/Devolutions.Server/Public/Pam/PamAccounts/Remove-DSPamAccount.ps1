function Remove-DSPamAccount {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [guid]$pamAccountID
    )

    BEGIN {
        Write-Verbose '[Remove-DSPamAccount] Beginning...'        

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    PROCESS {
        $URI = "$Script:DSBaseURI/api/pam/credentials/$pamAccountID" 

        $params = @{
            Uri    = $URI
            Method = 'DELETE'
        }

        $res = Invoke-DS @params
        return $res
    }
    END {
        If ($res.isSuccess) {
            Write-Verbose '[New-DSPamAccount] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamAccount] Ended with errors...'
        }
    }
}