function Close-DSSession{
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
			Uri = $URI
			Method = 'GET'
			LegacyResponse = $true
		}

		$response = Invoke-DS @params

		Clear-Variable -Name DSBaseURI -Scope Script
		Clear-Variable -Name DSKeyExp -Scope Script
		Clear-Variable -Name DSKeyMod -Scope Script
		Clear-Variable -Name DSSafeSessionKey -Scope Script
		Clear-Variable -Name DSInstanceVersion -Scope Script
		Clear-Variable -Name DSInstanceName -Scope Script
		Clear-Variable -Name DSSessionToken -Scope Script
		Clear-Variable -Name WebSession -Scope Script

		$response
	}

	END {   
		If ($?) {
			Write-Verbose '[Close-DSSession] Completed Successfully.'
	  	} else {
			Write-Verbose '[Close-DSSession] ended with errors...'
	  	}
	}
}