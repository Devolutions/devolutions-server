function New-DSPamAccount {
    <#
    .SYNOPSIS
    Creates a new PAM account
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [int]$credentialType,
        [Parameter(Mandatory)]
        [int]$protectedDataType,
        [Parameter(Mandatory)]
        [string]$folderID,
        [Parameter(Mandatory)]
        [string]$label,
        [Parameter(Mandatory)]
        [string]$username,
        [string]$password,
        [Parameter(Mandatory)]
        [string]$adminCredentialID
    )

    BEGIN {
        Write-Verbose '[New-DSPamAccount] Begining...'
        $URI = "$Script:DSBaseURI/api/pam/credentials"
        $isSuccess = $true

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }
    }
    PROCESS {
        if (![string]::IsNullOrEmpty($password)) {
            $password = Protect-ResourceToHexString $password
        }

        $PamCredentials = @{
            credentialType    = $credentialType
            protectedDataType = $protectedDataType
            folderID          = $folderID
            label             = $label
            username          = $username
            adminCredentialID = $adminCredentialID
            password          = $password
        }

        $params = @{
            Uri    = $URI
            Method = 'POST'
            Body   = $PamCredentials | ConvertTo-Json
        }

        $res = Invoke-DS @params
        $isSuccess = $res.isSuccess
        return $res
    }
    END {
        If ($isSuccess) {
            Write-Verbose '[New-DSPamAccount] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamAccount] Ended with errors...'
        }
    }
}