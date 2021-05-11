function Get-DSServerInfo {
	<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.NOTES
This endpoint does not require authentication.

.LINK
#>
	[CmdletBinding()]
	param(			
		[parameter(Mandatory)]
		[string]$BaseURI
	)
	
	BEGIN {
		Write-Verbose '[Get-DSServerInfo] Begin...'

		#We can call the api repeatedly, even after we've established the session.  We must close the existing session only if we change the URI
		if ((Get-Variable DSBaseURI -Scope Script -ErrorAction SilentlyContinue) -and ($Script:DSBaseURI -ne $BaseURI)) {
			if ($Global:DSSessionToken) {
				throw "Session already established, Close it before switching servers."
			}
		}

		#only time we use baseURI as provided, we will set variable only upon success
		$URI = "$BaseURI/api/server-information"
	}

	PROCESS {

		try {
			$response = Invoke-WebRequest -URI $URI -Method 'GET' -SessionVariable Global:WebSession
			$resContentJson = $response.Content | ConvertFrom-Json

			If (($null -ne $resContentJson) -and ($null -eq $resContentJson.errorMessage)) {
				$jsonContent = $response.Content | ConvertFrom-JSon
	
				Write-Verbose "[Get-DSServerInfo] Got response from ""$($jsonContent.data.servername)"""
				
				If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
					Write-Debug "[Response.Data] $($jsonContent)"
				}
				
				$publickey_mod = $jsonContent.data.publicKey.modulus
				$publickey_exp = $jsonContent.data.publicKey.exponent
				$session_Key = New-CryptographicKey
				$safeSessionKey = Encrypt-RSA -publickey_mod $publickey_mod -publickey_exp $publickey_exp -session_Key $session_Key

				[System.Version]$instanceVersion = $jsonContent.data.version

				Set-Variable -Name DSBaseURI -Value $BaseURI -Scope Script

				Set-Variable -Name DSKeyExp -Value $publickey_exp -Scope Global
				Set-Variable -Name DSKeyMod -Value $publickey_mod -Scope Global
				Set-Variable -Name DSSessionKey -Value $session_Key -Scope Global
				Set-Variable -Name DSSafeSessionKey -Value $safeSessionKey -Scope Global
				Set-Variable -Name DSInstanceVersion -Value $instanceVersion -Scope Global
				Set-Variable -Name DSInstanceName -Value $jsonContent.data.serverName -Scope Global

				return [ServerResponse]::new(($response.StatusCode -eq 200), $response, $jsonContent, $null, "", $response.StatusCode)
			}
			else {
				throw [Exception]::new("Could not connect to database. Make sure your database is running and you have the right credentials in DVLS Console.")
			}
		}
		catch {
			$exc = $_.Exception
			If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
				Write-Debug "[Exception] $exc"
			} 
		}
	}

	END {
		If ($?) {
			Write-Verbose '[Get-DSServerInfo] Completed Successfully.'
		}
		else {
			Write-Verbose '[Get-DSServerInfo] ended with errors...'
		}
	}
}