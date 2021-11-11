using module '..\enums\Gender.generated.psm1'

class ContactDetail
{
	[String]$Address = ''
	[String]$Cell = ''
	[String]$City = ''
	[String]$Company = ''
	[String]$Country = ''
	[String]$CustomerNumber = ''
	[String]$Email = ''
	[String]$Fax = ''
	[String]$FirstName = ''
	[Gender]$Gender = [Gender]::new()
	[String]$LastName = ''
	[String]$MiddleName = ''
	[String]$Phone = ''
	[String]$Prefix = ''
	[String]$Skype = ''
	[String]$State = ''
	[String]$Title = ''
	[String]$Website = ''
	[String]$WorkPhone = ''
	[String]$ZipCode = ''
}
