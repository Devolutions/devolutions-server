function New-DSSession-old {
	<#
.SYNOPSIS
Establishes a session with a Devolutions Server

.DESCRIPTION

.EXAMPLE

.LINK
#>
	[CmdletBinding()]
	param(	
		[ValidateNotNullOrEmpty()]
		[PSCredential]$Credential = $(throw 'Credential is null or empty. Please provide a valid PSCredential object and try again.'),
		[ValidateNotNullOrEmpty()]
		[string]$BaseURI = $(throw 'BaseURI is null or empty. Please provide a valid URI and try again.')
	)

	BEGIN { 
		Write-Verbose '[New-DSSession] Beginning...'

		if (Get-Variable DSSessionKey -Scope Global -ErrorAction SilentlyContinue) {
			throw 'Session already established. Close it before switching servers.'
		}

		#Get-ServerInfo must be called to get encryption keys...
		if (!(Get-Variable DSSessionKey -Scope Global -ErrorAction SilentlyContinue) -or [string]::IsNullOrWhiteSpace($Global:DSSessionKey)) {
			$info = Get-DSServerInfo -BaseURI $BaseURI
			if (!$info.isSuccess) {
				throw 'Unable to get server information'
			}
		}

		$URI = "$Script:DSBaseURI/api/login/partial"
	}

	PROCESS {
		$safePassword = Protect-ResourceToHexString $Credential.GetNetworkCredential().Password

		$Body = @{
			userName            = $Credential.UserName
			RDMOLoginParameters = @{
				SafePassword     = $safePassword
				SafeSessionKey   = $Global:DSSafeSessionKey
				Client           = 'Scripting'
				Version          = $MyInvocation.MyCommand.Module.Version.ToString()
				LocalMachineName = [Environment]::MachineName
				LocalUserName    = [Environment]::UserName
			}
		}

		if (Test-Path Global:DSHdr) {
			$Global:WebSession.Headers.Add($Global:DSHdr)
		}
		
		#body is typed as a HashTable, I'd like to offer an override that pushes the conversion downstream
		$response = Invoke-WebRequest -URI $URI -Method Post -ContentType 'application/json'  -Body ($Body | ConvertTo-Json) -WebSession $Global:WebSession
		If ($null -ne $response) {
			$jsonContent = $response.Content | ConvertFrom-JSon

			if ($null -eq $jsonContent) {
				$HasResult = $false
			}
			else {
				$HasResult = Get-Member -InputObject $jsonContent -Name 'result'
			}

			if (($HasResult) -and ('0' -eq $jsonContent.result)) {
				# some error occurred, we need to grab the message
				Write-Error $jsonContent.data.message -ErrorAction Stop
				#$res = [ServerResponse]::new(($false), $response, $jsonContent, $null, $jsonContent.data.message, [System.Net.HttpStatusCode]::Unauthorized)
				#return $res
			}
	
			Write-Verbose "[New-DSSession] Got authentication token $($jsonContent.data.tokenId)"
			Write-Verbose "[New-DSSession] Connected to ""$($jsonContent.data.serverInfo.servername)"""

			If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
				Write-Debug "[Response.Data] $($jsonContent.data)"
			}

			Set-Variable -Name DSSessionToken -Value $jsonContent.data.tokenId -Scope Global
			$Global:WebSession.Headers['tokenId'] = $jsonContent.data.tokenId

			$res = [ServerResponse]::new(($response.StatusCode -eq 200), $response, $jsonContent, $null, '', $response.StatusCode)
			return $res
		}

		$res = [ServerResponse]::new(($false), $null, $null, $null, '', 500)	
		return $res
	}

	END { 
		if ($res.isSuccess) {
			Write-Verbose '[New-DSSession ] Completed Successfully.'
		}
		else {
			Write-Verbose '[New-DSSession ] ended with errors...'
		}
	}

}