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
		if ($Script:DSBaseURI) { try { Remove-Variable -Name DSBaseURI -Scope Script -Force } catch { } }
		if ($Script:DSHdr) { try { Remove-Variable -Name DSHdr -Scope Script -Force } catch { } }
		if ($Script:DSInstanceName) { try { Remove-Variable -Name DSInstanceName -Scope Script -Force } catch { } }
		if ($Script:DSKeyExp) { try { Remove-Variable -Name DSKeyExp -Scope Script -Force } catch { } }
		if ($Script:DSKeyMod) { try { Remove-Variable -Name DSKeyMod -Scope Script -Force } catch { } }
		if ($Script:DSSafeSessionKey) { try { Remove-Variable -Name DSSafeSessionKey -Scope Script -Force } catch { } }
		if ($Script:DSSessionKey) { try { Remove-Variable -Name DSSessionKey -Scope Script -Force } catch { } }

		#global scope
		if ($Global:DSInstanceVersion) { try { Remove-Variable -Name DSInstanceVersion -Scope Global -Force } catch { } }
		if ($Global:DSSessionKey) {	try { Remove-Variable -Name DSSessionKey -Scope Global -Force } catch { } }
		if ($Global:DSSessionToken) { try { Remove-Variable -Name DSSessionToken -Scope Global -Force } catch { } }
		if ($Global:WebSession) { try { Remove-Variable -Name WebSession -Scope Global -Force } catch { } }

		$response 
	}

	END {   
		Write-Verbose '[Close-DSSession] ...end'
	}
}