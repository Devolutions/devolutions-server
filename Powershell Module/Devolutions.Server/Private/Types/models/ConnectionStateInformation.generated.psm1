using module '..\enums\ConnectionStateType.generated.psm1'

class ConnectionStateInformation
{
	[String]$ConnectionID = $null
	[String]$ExpirationDate = $null
	[String]$MachineName = ''
	[ConnectionStateType]$State = [ConnectionStateType]::new()
	[String]$UserID = $null
}
