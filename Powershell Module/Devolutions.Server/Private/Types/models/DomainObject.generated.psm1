using module '..\enums\DomainObjectType.generated.psm1'

class DomainObject
{
	[String]$DisplayName = ''
	[String]$DN = ''
	[String]$JsonData = ''
	[String]$Sid = ''
	[boolean]$HasSubOus = $false
	[DomainObjectType]$Type = [DomainObjectType]::new()
}
