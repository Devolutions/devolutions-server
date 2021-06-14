function Get-DSIsLogged {
	<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.LINK
#>
	[CmdletBinding()]
	param(	)

	BEGIN { 
		Write-Verbose '[Get-DSIsLogged] Beginning...'
		$URI = "$Script:DSBaseURI/api/is-logged"
	}

	PROCESS {

		$params = @{
			Uri            = $URI
			Method         = 'GET'
			LegacyResponse = $true
		}

		try {
			$response = Invoke-DS @params
			return $response 
		}
		catch {
			Write-Error $_.Exception.Message
		}
	}

	END {   
		Write-Verbose '[Get-DSIsLogged] ...end'
	}
}