function Close-DSSession-old {
	<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.LINK
#>
	[CmdletBinding()]
	param(
		[switch]$Force
	)

	BEGIN { 
		Write-Verbose '[Close-DSSession] begin...'
		$URI = "$Script:DSBaseURI/api/logout"
		$GlobalVars = @('DSInstanceName', 'DSInstanceVersion', 'DSKeyExp', 'DSKeyMod', 'DSSafeSessionKey', 'DSSessionKey', 'DSSessionToken', 'WebSession') 
	}

	PROCESS {
		try {
			if (!$Force) {
				$params = @{
					Uri            = $URI
					Method         = 'GET'
					LegacyResponse = $true
				}

				$response = Invoke-DS @params
			}

			#script scope
			if (Get-Variable DSBaseUri -Scope Script -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSBaseURI -Scope Script -Force } catch { } }

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