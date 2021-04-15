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

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }

    PROCESS {
        $params = @{
            Uri    = $URI
            Method = 'GET'
        }

        $res = Invoke-DS @params
        return $res
    }

    END {
        If ($res.isSuccess) {
            Write-Verbose '[Get-DSRoles] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSRoles] Ended with errors...'
        }
    }    
}