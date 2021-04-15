function Remove-DSRole {
    <#
    .SYNOPSIS
    Deletes a role
    .EXAMPLE
    $res = Delete-DSRole -roleId "*roleIdToDelete*"
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [guid]$roleId
    )

    BEGIN {
        Write-Verbose '[Delete-DSRole] Begining...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }

    PROCESS {
        $URI = "$Script:DSBaseURI/api/security/roleinfo/delete/$roleId"

        $params = @{
            Uri    = $URI
            Method = 'DELETE'
        }

        $res = Invoke-DS @params
        return $res
    }

    END {
        If ($res.isSuccess) {
            Write-Verbose '[Delete-DSRole] Completed Successfully.'
        }
        else {
            Write-Verbose '[Delete-DSRole] Ended with errors...'
        }
    }    
}