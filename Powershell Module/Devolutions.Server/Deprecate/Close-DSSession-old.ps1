function Close-DSSession-old {
	<#
		.SYNOPSIS
		Terminate the connection with your Devolutions Server instance.
		.DESCRIPTION
		Terminate the connection with your Devolutions Server by clearing global variables required to keep it up and running.
	#>
	[CmdletBinding()]
	param(
		#Clear session variables without calling endpoint to render time-based token outdated.
		[switch]$Force
	)

	BEGIN { 
		Write-Verbose '[Close-DSSession] Beginning...'
		$URI = "$Script:DSBaseURI/api/logout"
		$GlobalVars = @('DSInstanceName', 'DSInstanceVersion', 'DSKeyExp', 'DSKeyMod', 'DSSafeSessionKey', 'DSSessionKey', 'DSSessionToken', 'WebSession') 
	}

	PROCESS {
		try {
			if (!$Force) {
				$params = @{
					Uri            = $URI
					Method         = 'GET'
				}

				$response = Invoke-DS @params
			}

			#script scope
			if (Get-Variable DSBaseUri -Scope Script -ErrorAction SilentlyContinue) { 
				try {
					Remove-Variable -Name DSBaseURI -Scope Script -Force 
				}
				catch {
					Write-Warning "[Close-DSSession] Error while removing $Var..."
				} 
			}

			#global scope
			foreach ($Var in $GlobalVars.GetEnumerator()) {
				try {
					Remove-Variable -Name $Var -Scope Global -Force -ErrorAction SilentlyContinue
				}
				catch {
					Write-Warning "[Close-DSSession] Error while removing $Var..."
				}
			}

			if (!$Force) {
				return $response 
			}
		}
		catch {
			Write-Error $_.Exception.Message
		}
	}

	END {   
		Write-Verbose '[Close-DSSession] ...end'
	}
}