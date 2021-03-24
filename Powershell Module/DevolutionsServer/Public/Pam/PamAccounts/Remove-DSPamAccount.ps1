function Delete-DSPamAccount {
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
        [int]$pamAccountID
    )

    BEGIN {
        Write-Verbose '[New-DSPamAccount] Begining...'
        if (!$pamAccountID) {
            $URI = "$Script:DSBaseURI/api/pam/credentials/$pamAccountID"
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

        return Invoke-DS @params
    }
    END {
        If ($?) {
            Write-Verbose '[New-DSPamAccount] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamAccount] Ended with errors...'
        }
    }
}