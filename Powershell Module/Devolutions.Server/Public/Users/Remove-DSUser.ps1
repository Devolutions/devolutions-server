function Remove-DSUser {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [guid]$CandidUserId
    )

    BEGIN {
        Write-Verbose '[Delete-DSUser] Beginning...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    PROCESS {   
        $URI = "$Script:DSBaseURI/api/security/userinfo/delete/$candidUserId"

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