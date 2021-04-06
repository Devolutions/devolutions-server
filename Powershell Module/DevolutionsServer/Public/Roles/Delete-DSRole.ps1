function Delete-DSRole {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$roleId
    )

    BEGIN {
        Write-Verbose '[Delete-DSRole] Begining...'
        $URI = "$Script:DSBaseURI/api/security/roleinfo/delete/$roleId"
        $isSuccess = $true

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
            Write-Verbose '[Delete-DSRole] Completed Successfully.'
        }
        else {
            Write-Verbose '[Delete-DSRole] Ended with errors...'
        }
    }    
}