using module '..\models\DomainGroupItem.generated.psm1'
using module '..\enums\DomainType.generated.psm1'

class DomainUserInfo
{
	[boolean]$AlreadyAdded = $false
	[String]$DistinguishedName = ''
	[String]$DomainName = ''
	[DomainType]$DomainType = [DomainType]::new()
	[String]$Email = ''
	[String]$FirstName = ''
	[DomainGroupItem]$Groups = [DomainGroupItem]::new()
	[String]$ID = $null
	[String]$LastName = ''
	[String]$LastSync = $null
	[String]$NetBiosName = ''
	[String]$SamAccountName = ''
	[String]$Sid = ''
	[String]$UPN = ''
	[String]$UserId = $null
}
