using module '..\enums\ConnectionStatusBehavior.generated.psm1'

class StatusParameter
{
	[ConnectionStatusBehavior]$Status = [ConnectionStatusBehavior]::new()
	[String]$Message = ''
	[String]$ExpirationDate = $null
}
