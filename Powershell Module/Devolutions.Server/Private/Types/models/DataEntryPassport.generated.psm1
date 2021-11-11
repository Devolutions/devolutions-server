using module '..\enums\Gender.generated.psm1'

class DataEntryPassport
{
	[String]$CountryCode = ''
	[String]$Expiration = $null
	[String]$FirstName = ''
	[Gender]$Gender = [Gender]::new()
	[String]$LastName = ''
	[String]$MiddleName = ''
	[String]$NumberItem = ''
	[String]$Url = ''
}
