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
		$URI = "$Script:DSBaseURI/api/logout"
	}

	PROCESS {

		$params = @{
			Uri            = $URI
			Method         = 'GET'
			LegacyResponse = $true
		}

		try {
			$response = Invoke-DS @params
		}
		catch {
			#if we have an exception doing the logoff, its better that clear the variables anyway...
		}

		#script scope
		if (Get-Variable DSBaseUri -Scope Script -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSBaseURI -Scope Script -Force } catch { } }
		if (Get-Variable DSKeyExp -Scope Script -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSKeyExp -Scope Script -Force } catch { } }
		if (Get-Variable DSKeyMod -Scope Script -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSKeyMod -Scope Script -Force } catch { } }
		if (Get-Variable DSSafeSessionKey -Scope Script -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSSafeSessionKey -Scope Script -Force } catch { } }
		if (Get-Variable DSInstanceName -Scope Script -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSInstanceName -Scope Script -Force } catch { } }

		#global scope
		if (Get-Variable DSSessionKey -Scope Global -ErrorAction SilentlyContinue) {	try { Remove-Variable -Name DSSessionKey -Scope Global -Force } catch { } }
		if (Get-Variable DSSessionToken -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSSessionToken -Scope Global -Force } catch { } }
		if (Get-Variable WebSession -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name WebSession -Scope Global -Force } catch { } }
		if (Get-Variable DSInstanceVersion -Scope Global -ErrorAction SilentlyContinue) { try { Remove-Variable -Name DSInstanceVersion -Scope Global -Force } catch { } }

		$response 
	}

	END {   
		Write-Verbose '[Close-DSSession] ...end'
	}
}