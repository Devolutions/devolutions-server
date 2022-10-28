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
        [Parameter(ParameterSetName = 'Paging')]
        [int]$PageSize = 100,
        [Parameter(ParameterSetName = 'Paging')]
        [int]$PageNumber = 1,
        [Parameter(ParameterSetName = 'GetById')]
        [string]$Id
    )

    BEGIN {
        Write-Verbose '[Get-DSRoles] Beginning...'
        
        $URI = switch ($PSCmdlet.ParameterSetName) {
            { $_ -in 'GetAll', 'Paging' } { "$Script:DSBaseURI/api/v3/usergroups?pageSize=$PageSize&pageNumber=$PageNumber&sortOrder=1" }
            'GetById' { "$Script:DSBaseURI/api/security/roles/$Id" }
        }

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