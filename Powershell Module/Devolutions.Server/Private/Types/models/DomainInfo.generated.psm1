using module '..\models\DomainGroup.generated.psm1'
using module '..\enums\DomainType.generated.psm1'

class DomainInfo
{
	[String]$DisplayName = ''
	[String]$DomainName = ''
	[DomainType]$DomainType = [DomainType]::new()
	[DomainGroup]$GroupNames = [DomainGroup]::new()
	[String]$ID = $null
	[String]$LastSync = $null
	[String]$NetbiosName = ''
}
