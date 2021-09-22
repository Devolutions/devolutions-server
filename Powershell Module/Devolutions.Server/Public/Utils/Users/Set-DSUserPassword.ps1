function Set-DSUserPassword {
    [CmdletBinding()]
    PARAM (
        [string]$Username,
        [string]$EncryptedPassword
    )

    BEGIN {
        Write-Verbose "[]"

        $URI = "$Script:DSBaseURI/api/resetpassword"
    }

    PROCESS {
        $RequestBody = @{
            UserName        = $Username
            SafeNewPassword = $EncryptedPassword
        }

        $RequestParams = @{
            URI    = $URI
            Method = "PUT"
            Body   = $RequestBody | ConvertTo-Json -Depth 100
        }

        Invoke-DS @RequestParams -Verbose
    }
}