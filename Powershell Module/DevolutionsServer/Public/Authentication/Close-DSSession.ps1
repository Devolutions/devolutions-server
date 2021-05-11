function Close-DSSession {
	<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.LINK
#>
	[CmdletBinding()]
	param(	)

	BEGIN { 
		Write-Verbose '[Close-DSSession] begin...'
		$URI = "$env:DS_URL/api/logout"
	}

	PROCESS {
		$GlobalVars = @('DSBaseUri', 'DSKeyExp', 'DSKeyMod', 'DSSafeSessionKey', 'DSInstanceName', 'DSSessionKey', 'DSSessionToken', 'WebSession', 'DSInstanceVersion')

		$params = @{
			Uri            = $URI
			Method         = 'GET'
			LegacyResponse = $true
		}

		try {
			$response = Invoke-DS @params

			foreach ($var in $GlobalVars) {
				if (Get-Variable $var -Scope Global -ErrorAction SilentlyContinue) {
					try {
						Remove-Variable -Name $var -Scope Global -Force
					}
					catch {
						Write-Error "[Close-DSSession] Error while clearing $var from instance."
					}
				}
			}
			
			return $response 
		}
		catch {
			Write-Error $_.Exception.Message
		}
	}

	END {   
		Write-Verbose '[Close-DSSession] ...End'
	}
}