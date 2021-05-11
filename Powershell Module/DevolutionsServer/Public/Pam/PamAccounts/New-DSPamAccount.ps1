function New-DSPamAccount {
    <#
    .SYNOPSIS
    Creates a new PAM account
    #>
    [CmdletBinding()]
    #TODO Check credentialType & protectedDataType once PAM enums are added.
    param(
        [ValidateNotNullOrEmpty()]
        [int]$credentialType,
        [ValidateNotNullOrEmpty()]
        [int]$protectedDataType,
        [ValidateNotNullOrEmpty()]
        [guid]$folderID,
        [ValidateNotNullOrEmpty()]
        [string]$label,
        [ValidateNotNullOrEmpty()]
        [string]$username,
        [string]$password,
        [ValidateNotNullOrEmpty()]
        [guid]$adminCredentialID
    )

    BEGIN {
        Write-Verbose '[New-DSPamAccount] Beginning...'
        $URI = "$Script:DSBaseURI/api/pam/credentials"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
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
        return $res
    }
    END {
        If ($res.isSuccess) {
            Write-Verbose '[New-DSPamAccount] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamAccount] Ended with errors...'
        }
    }
}