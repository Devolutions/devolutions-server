function Get-DSUsers {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param(
        [switch]$All,
        [guid]$candidUserId,
        [int]$pageSize = 10,
        [int]$pageNumber = 1
    )

    BEGIN {
        Write-Verbose '[Delete-DSUser] Beginning...'
        
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    PROCESS { 
        $URI = if ($All) { 
            "$Script:DSBaseURI/api/security/users/list" 
        }
        elseif ($candidUserId) {
            "$Script:DSBaseURI/api/security/user/${candidUserId}?csFromXml=1&loadGroup=1" 
        }
        else { 
            "$Script:DSBaseURI/api/v3/users?pageSize=$pageSize&pageNumber=$pageNumber&sortOrder=1&includeImages=false" 
        }

        $params = @{
            Uri    = $URI
            Method = 'GET'
        }

        $res = Invoke-DS @params
        return $res
    }
    END {
        If ($res.isSuccess) {
            Write-Verbose '[Get-DSUsers] Completed successfully.'
        }
        else {
            Write-Verbose "[Get-DSUsers] Error: $($res.Body.errorMessage)"
        }
    }
}