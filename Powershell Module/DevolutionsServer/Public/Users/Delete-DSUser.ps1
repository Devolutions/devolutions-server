function Delete-DSUser {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$candidUserId
    )

    BEGIN {
        Write-Verbose '[Delete-DSUser] Begining...'
        $URI = "$Script:DSBaseURI/api/security/userinfo/delete/$candidUserId"
        $isSuccess = $true

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }

        if (![guid]::TryParse($candidUserId, $([ref][guid]::Empty))) {
            throw "User ID is not valid. Please provide a valid ID."
        }
    }
    PROCESS {   
        $params = @{
            Uri    = $URI
            Method = 'DELETE'
        }

        $res = Invoke-DS @params
        return $res
    }
    END {
        If ($res.isSuccess) {
            Write-Verbose '[Delete-DSUser] Completed successfully.'
        }
        else {
            Write-Verbose "[Delete-DSUser] Error: $($res.ErrorMessage)"
        }
    }
}