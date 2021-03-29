function Get-DSPamAccounts {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$folderID
    )

    BEGIN {
        Write-Verbose '[Get-DSPamAccount] Begining...'
        $URI = "$Script:DSBaseURI/api/pam/credentials"
        $isSuccess = $true

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }

        if ([string]::IsNullOrWhiteSpace($folderID)) {
            $isSuccess = $false
            throw "There was a problem loading credentials from folder: folderID null or invalid."
        }
    }
    PROCESS {
        $params = @{
            Uri    = $URI
            Method = 'GET'
            Body   = $folderID
        }

        $res = Invoke-DS @params
        $isSuccess = $res.isSuccess
        return $res
    }
    END {
        If ($isSuccess) {
            Write-Verbose '[Get-DSPamAccount] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSPamAccount] Ended with errors...'
        }
    }
}