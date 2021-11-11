using module '..\models\IEnumerable`1.generated.psm1'

class MsGroup
{
	[String]$Name = ''
	[String]$DistinguishedName = ''
	[String]$DomainName = ''
	[String]$Sid = ''
	[IUser[]]$Users = $null
}
