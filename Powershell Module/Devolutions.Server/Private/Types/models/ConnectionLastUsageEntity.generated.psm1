using module '..\enums\ConnectionType.generated.psm1'

class ConnectionLastUsageEntity
{
	[String]$CreationDate = $null
	[String]$Group = ''
	[String]$Id = $null
	[String]$LastModifiedOn = $null
	[String]$LastOpenedOn = $null
	[String]$LastViewedOn = $null
	[String]$Name = ''
	[String]$PasswordLastViewedOn = $null
	[ConnectionType]$Type = [ConnectionType]::new()
	[String]$TypeName = ''
}
