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

		$params = @{
			Uri            = $URI
			Method         = 'GET'
			LegacyResponse = $true
		}

		try {
			$response = Invoke-DS @params

			#script scope
			if (Get-Variable DSBaseUri -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSBaseURI -Scope Global -Force } catch { } }
			if (Get-Variable DSKeyExp -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSKeyExp -Scope Global -Force } catch { } }
			if (Get-Variable DSKeyMod -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSKeyMod -Scope Global -Force } catch { } }
			if (Get-Variable DSSafeSessionKey -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSSafeSessionKey -Scope Global -Force } catch { } }
			if (Get-Variable DSInstanceName -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSInstanceName -Scope Global -Force } catch { } }

			#global scope
			if (Get-Variable DSSessionKey -Scope Global -ErrorAction SilentlyContinue) {	try { Remove-Variable -Name DSSessionKey -Scope Global -Force } catch { } }
			if (Get-Variable DSSessionToken -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSSessionToken -Scope Global -Force } catch { } }
			if (Get-Variable WebSession -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name WebSession -Scope Global -Force } catch { } }
			if (Get-Variable DSInstanceVersion -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSInstanceVersion -Scope Global -Force } catch { } }

			return $response 
		}
		catch {
			Write-Error $_.Exception.Message
		}
	}

	END {   
		Write-Verbose '[Close-DSSession] ...end'
	}
}