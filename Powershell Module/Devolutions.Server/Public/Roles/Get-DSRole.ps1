function Get-DSRole {
    <#
    .SYNOPSIS
    Fetch all the currently existing roles.
    .EXAMPLE
    > Get-DSRole -PageSize 20 -PageNumber 3
    [ServerResponse]@{
        ...
        Body = @{
            data = @{
                @{Role 1...}
                @{Role 2...}
                @{Role 3...}
            }
        }
    }
    #>
    [CmdletBinding(DefaultParameterSetName = 'Paging')]
    param(
        [Parameter(ParameterSetName = 'GetAll')]
        [switch]$GetAll,
        [int]$PageSize = 100,
        [int]$PageNumber = 1
    )

    BEGIN {
        Write-Verbose '[Get-DSRoles] Beginning...'
        $URI = "$Script:DSBaseURI/api/v3/usergroups?pageSize=$PageSize&pageNumber=$PageNumber&sortOrder=1"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
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