function Get-DSRoles {
    <#
    .SYNOPSIS
    Fetch all the currently existing roles.
    .EXAMPLE
    $res = Get-DSRoles
    $rolesList = (Get-DSRoles).Body.data
    #>
    [CmdletBinding()]
    param(
    )

    BEGIN {
        Write-Verbose '[Get-DSRoles] Begining...'
        $URI = "$Script:DSBaseURI/api/v3/usergroups"
        $isSuccess = $true

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }

    PROCESS {
        $params = @{
            Uri    = $URI
            Method = 'GET'
        }

        $res = Invoke-DS @params
        $isSuccess = $res.isSuccess
        return $res
    }

    END {
        If ($isSuccess) {
            Write-Verbose '[Get-DSRoles] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSRoles] Ended with errors...'
        }
    }    
}