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
        #[Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$pamAccountID
    )

    BEGIN {
        Write-Verbose '[Remove-DSPamAccount] Begining...'        

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }

        if ([guid]::TryParse($pamAccountID, $([ref][guid]::Empty))) {
            throw "Please provide a valid ID."
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