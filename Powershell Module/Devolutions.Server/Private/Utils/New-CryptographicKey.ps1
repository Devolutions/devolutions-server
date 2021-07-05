function New-CryptographicKey{
    <#
    .SYNOPSIS
        Generates a Cryptographic key specifically for communicating
        with Devolutions Server
    .DESCRIPTION

    .NOTES
        Uses the Default 256bit key size but encodes in a Hex string	
    #>
    [cmdletbinding()]
    [OutputType([string])]
    param(
        [int]$KeySize = 256
    )
    
    BEGIN{
        Write-Verbose '[New-CryptographicKey] begin...'
    }

    PROCESS {
        try{
            $aesManaged = [System.Security.Cryptography.AesManaged]::new()
            $aesManaged.KeySize = $KeySize
            $aesManaged.GenerateKey | Out-Null

            return Convert-BytesToHex $aesManaged.Key
        }
        finally{
            if($aesManaged -is [IDisposable]){
                $aesManaged.Dispose()
            }
        }
    }
    
    END{
        If ($?) {
            Write-Verbose '[New-CryptographicKey] Completed Successfully.'
        } else {
            Write-Verbose '[New-CryptographicKey] ended with errors...'
        }
    }
}
