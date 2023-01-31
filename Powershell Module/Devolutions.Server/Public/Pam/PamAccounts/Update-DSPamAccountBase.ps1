function Update-DSPamAccountBase {
    <#
    .SYNOPSIS
    Updates a PAM account.

    .DESCRIPTION
    Updates a PAM account using the object returned by "Get-DSPamAccount" (and the password parameter, if present).

    .EXAMPLE
    > $PamAccount = (Get-DSPamAccount $PamAccountId).Body

    $PamAccount.description = $NewDescription
    $PamAccount.username = $NewUsername
    $PamAccount.password = $NewPassword

    > $Response = Update-DSPamAccountBase $PamAccount
    #>
    
    [CmdletBinding()]
    param (
        $PamAccount,
        [string]$Password
    )
    
    begin {
        Write-Verbose '[New-DSPamAccount] Beginning...'
        $URI = "$Script:DSBaseURI/api/pam/credentials"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }
    }
    
    process {
        if (!($ExistingPamAccount = (Get-DSPamAccount $PamAccount.id).Body)) {
            throw 'Could not find the requested PAM account.'
        }

        if ($Password) {
            $PamAccount | Add-Member -NotePropertyName 'password' -NotePropertyValue $Password
        }
        
        $params = @{
            Uri    = "$URI/$($PamAccount.id)"
            Method = 'PUT'
            Body   = $PamAccount | ConvertTo-Json
        }

        $res = Invoke-DS @params
        return $res
    }
    
    end {
        Write-Verbose ($res.isSuccess ? '[Update-DSPamAccount] Completed Successfully.' : '[Update-DSPamAccount] Ended with errors...')
    }
}