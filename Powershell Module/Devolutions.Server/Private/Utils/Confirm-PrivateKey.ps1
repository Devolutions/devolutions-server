function Confirm-PrivateKey {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [string]$PathToFile
    )

    BEGIN {
        Write-Verbose '[Confirm-PrivateKey] Beginning...'
        
        $URI = "$Script:DSBaseURI/api/private-key/upload"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }

    PROCESS {
        $FileContent = Get-Content $PathToFile | Out-String

        $boundary = [guid]::NewGuid()
        $lf = "`r`n"

        $bodyLines = (
            "--$boundary",
            "Content-Disposition: form-data; name=`"privateKeyFile`"; filename=`"private.ppk`"",
            "Content-Type: application/x-putty-private-key$LF",
            $FileContent,
            "--$boundary--"
        ) -join $LF

        $RequestParams = @{
            Uri         = $URI
            Method      = 'POST'
            ContentType = "multipart/form-data; boundary=`"$boundary`""
            body        = $bodyLines
        }

        $res = Invoke-DS @RequestParams

        #FIXME Maybe this isn't right and we should decrypt data instead, but the decrypt cmdlet is supposed to be legacy. Check with Maurice
        if ($res.Body.result -eq [Devolutions.RemoteDesktopManager.SaveResult]::Success) {
            $res.Body | Add-Member -NotePropertyName 'privateKeyData' -NotePropertyValue $FileContent
        }

        return $res
    }

    END {
        if ($res.isSuccess) {
            Write-Verbose "[Confirm-PrivateKey] Completed successfully!"
        }
        else {
            Write-Verbose "[Confirm-PrivateKey] Ended with errors..."
        }
    }
}