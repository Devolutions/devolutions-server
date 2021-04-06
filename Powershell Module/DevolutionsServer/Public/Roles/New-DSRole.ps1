function New-DSRole {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$displayName,
        [string]$description,
        [bool]$isAdministrator
    )

    BEGIN {
        Write-Verbose '[New-DSRole] Begining...'
        $URI = "$Script:DSBaseURI/api/security/role/save"
        $isSuccess = $true

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }

    PROCESS {
        $newRoleData = @{
            userAccount = @{
                fullName = $description
            }
            userSecurity = @{
                name            = $displayName
                isAdministrator = $isAdministrator
            }
        }

        $params = @{
            Uri    = $URI
            Method = 'PUT'
            Body   = $newRoleData | ConvertTo-Json
        }

        $res = Invoke-DS @params
        $isSuccess = $res.isSuccess
        return $res
    }

    END {
        If ($isSuccess) {
            Write-Verbose '[New-DSCustomUser] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSCustomUser] Ended with errors...'
        }
    }    
}