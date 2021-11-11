using module '..\models\IEnumerable`1.generated.psm1'

class MsUser
{
	[String]$DomainName = ''
	[String]$DomainNetBios = ''
	[String]$DisplayName = ''
	[String]$FirstName = ''
	[String]$LastName = ''
	[String]$EmailAddress = ''
	[String]$DistinguishedName = ''
	[String]$Container = ''
	[String]$SamAccountName = ''
	[String]$UserPrincipalName = ''
	[String]$Username = ''
	[String]$Sid = ''
	[IGroup[]]$Groups = $null
}
