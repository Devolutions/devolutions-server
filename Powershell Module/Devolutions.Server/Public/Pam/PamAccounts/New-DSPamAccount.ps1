function New-DSPamAccount {
    <#
    .SYNOPSIS
    Creates a new PAM account
    .EXAMPLE
    $RequestParams = @{
        credentialType = [PamCredentialType]::LocalUser
        folderID       = $ParentFolderId
        name          = 'NewPamAccount'
        username       = 'Username'
        password       = $null
        providerId     = $ProviderId
    }

    > New-DSPamAccount @RequestParams
    #>
    [CmdletBinding()]
    #TODO Check credentialType & protectedDataType once PAM enums are added.
    param(
        [ValidateNotNullOrEmpty()]
        #Account's credential type
        [PamCredentialType]$credentialType,
        [ValidateNotNullOrEmpty()]
        [guid]$folderID,
        [ValidateNotNullOrEmpty()]
        [string]$name,
        [ValidateNotNullOrEmpty()]
        [string]$username,
        [string]$password,
        [ValidateNotNullOrEmpty()]
        #Provider's ID
        [guid]$providerId
    )

    BEGIN {
        Write-Verbose '[New-DSPamAccount] Beginning...'
        $URI = "$Script:DSBaseURI/api/pam/credentials"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }
    }
    PROCESS {
        if (![string]::IsNullOrEmpty($password)) {
            $password = $password
        }

        $protectedDataType = switch ($credentialType) {
            ([PamCredentialType]::Unknown) { [PamProtectedDataType]::Unknown }
            ([PamCredentialType]::Certificate) { [PamProtectedDataType]::Certificate }
            Default { [PamProtectedDataType]::Password }
        }

        $PamCredentials = @{
            credentialType    = $credentialType
            protectedDataType = $protectedDataType
            folderID          = $folderID
            label             = $label
            username          = $username
            adminCredentialID = $providerId
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