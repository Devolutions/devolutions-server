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
        $key
	)
	
	BEGIN{
        Write-Verbose '[New-AESService] begin...'
	}

	PROCESS {
	
		$aesManaged = [System.Security.Cryptography.AesManaged]::new()
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