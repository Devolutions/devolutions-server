function Encrypt-RSA {
<#
.SYNOPSIS
Legacy - Do not use
.DESCRIPTION

.EXAMPLE

.LINK
#>

	[CmdletBinding()]
	param(			
		[parameter(Mandatory)]
		[string]$publickey_mod,
		[parameter(Mandatory)]
		[string]$publickey_exp,
		[parameter(Mandatory)]
		[string]$session_Key		
	)

	BEGIN {
        Write-Verbose '[Encrypt-RSA] Beginning...'
	}
	
    PROCESS{
	
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $parameters = New-Object System.Security.Cryptography.RSAParameters

#	[byte[]]$publickey_mod_bytes = 
#   [byte[]]$publickey_exp_bytes =
	
    $parameters.modulus = Convert-HextoBytes $publickey_mod
    $parameters.Exponent =  Convert-HextoBytes $publickey_exp
    $rsa.ImportParameters($parameters)
    $safeSessionKey = $rsa.Encrypt([System.Text.Encoding]::UTF8.GetBytes($session_Key), $false)
    $safeSessionKey = Convert-BytesToHex  $safeSessionKey

    return $safeSessionKey
	}
	
	END{
        If ($?) {
          Write-Verbose '[Encrypt-RSA] Completed Successfully.'
        } else {
	        Write-Verbose '[Encrypt-RSA] ended with errors...'
		}
	}
}