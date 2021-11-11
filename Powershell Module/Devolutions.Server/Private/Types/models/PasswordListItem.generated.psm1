using module '..\models\PasswordListCustomValue.generated.psm1'

class PasswordListItem
{
	[PasswordListCustomValue]$CustomProperties = [PasswordListCustomValue]::new()
	[String]$Description = ''
	[String]$Domain = ''
	[String]$ExpirationDateTime = $null
	[String]$ExpirationDateTimeString = ''
	[boolean]$Expire = $false
	[String]$Host = ''
	[String]$Id = ''
	[String]$Password = ''
	[string[]]$Roles = [string[]]::new()
	[String]$SafePassword = ''
	[int]$SortPriority = 0
	[String]$User = ''
}
