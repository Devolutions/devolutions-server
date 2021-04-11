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
        [Parameter(Mandatory)]
        [string]$pamAccountID
    )

    BEGIN {
        Write-Verbose '[Remove-DSPamAccount] Begining...'
        #TODO:MOVE in process block
        if (![string]::IsNullOrEmpty($pamAccountID)) {
            $URI = "$Script:DSBaseURI/api/pam/credentials/$pamAccountID"
        } else {
            throw "Invalid PAM account ID. Please double check entered value."
        }

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    PROCESS {
        $params = @{
            Uri    = $URI
            Method = 'DELETE'
        }

        $res = Invoke-DS @params
        $isSuccess = $res.isSuccess
        return $res
    }
    END {
        If ($isSuccess) {
            Write-Verbose '[New-DSPamAccount] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamAccount] Ended with errors...'
        }
    }
}