function Get-DSServerInfo-old {
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
		Write-Verbose '[Get-DSServerInfo] Beginning...'

		#We can call the api repeatedly, even after we've established the session.  We must close the existing session only if we change the URI
		if ((Get-Variable DSBaseURI -Scope Script -ErrorAction SilentlyContinue) -and ($Script:DSBaseURI -ne $BaseURI)) {
			if ($Global:DSSessionToken) {
				throw 'Session already established, Close it before switching servers.'
			}
		}

		#only time we use baseURI as provided, we will set variable only upon success
		$URI = "$BaseURI/api/server-information"
	}

	PROCESS {
		try {
			$response = Invoke-WebRequest -URI $URI -Method 'GET' -SessionVariable Global:WebSession

			if (Test-Json $response.Content) {
				$jsonContent = $response.Content | ConvertFrom-JSon
				#If query successful and reached a valid DVLS instance, response's content converted to JSON should only contain 'data' and 'result' fields.
				$isDVLSInstance = @(Compare-Object $jsonContent.PSObject.Properties.Name @('data', 'result')).Length -eq 0

				if ($isDVLSInstance) {
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

					$res = [ServerResponse]::new(($response.StatusCode -eq 200), $response, $jsonContent, $null, '', $response.StatusCode)
					return $res
				}
				else {
					throw 'There was a problem reaching your DVLS instance. Please check your DVLS instance URL and try again.'
				}
			}
			else {
				throw 'There was a problem reaching your DVLS instance. Please check your DVLS instance URL and try again.'
			}
		}
		catch {
			#$exc = $_.Exception
			#If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
			#	Write-Debug "[Exception] $exc"
			#} 

			Write-Error 'There was a problem reaching your DVLS instance. Please check your DVLS instance URL and try again.'
			throw $_.Exception.Message
		}
	}

	END {
		If ($res.isSuccess) {
			Write-Verbose '[Get-DSServerInfo] Completed Successfully!'
		}
		else {
			Write-Verbose '[Get-DSServerInfo] Ended with errors...'
		}
	}
}