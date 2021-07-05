function New-AESService{
<#
.SYNOPSIS
Creates a new AES crypto service with our desired parameters.   
.DESCRIPTION
Creates a new AES crypto service with our desired parameters.  Built specifically for communicating with Devolutions Server
.PARAMETER key
A secret key to use
#>
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
		$key,
		$InitVector
	)
	
	BEGIN{
        Write-Verbose '[New-AESService] Beginning...'
	}

	PROCESS {
	
		$aesManaged = [System.Security.Cryptography.AesManaged]::new()

		if ($InitVector) {
			if ($InitVector.getType().Name -eq "String") {
				$aesManaged.IV = Convert-HexToBytes $InitVector
			}
			else {
				$aesManaged.IV = $InitVector
			}
		}

		if ($key.getType().Name -eq "String") {
			$aesManaged.Key = Convert-HexToBytes $key
		}
		else {
			$aesManaged.Key = $key
		}

		return $aesManaged
	}
	
	END{
		If ($?) {
			Write-Verbose '[New-AESService] Completed Successfully.'
		} else {
			Write-Verbose '[New-AESService] ended with errors...'
		}
	}
}