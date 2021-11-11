using module '..\enums\ServerUserType.generated.psm1'
using module '..\enums\UserType.generated.psm1'

class UserListItem
{
	[ServerUserType]$AuthenticationType = [ServerUserType]::new()
	[String]$Email = ''
	[String]$FullName = ''
	[String]$GravatarEmail = ''
	[String]$IconUrl = ''
	[String]$ID = $null
	[boolean]$IsAdministrator = $false
	[boolean]$IsEnabled = $false
	[String]$LastLogindate = $null
	[String]$Name = ''
	[boolean]$Reset2fa = $false
	[String]$UserTypeString = ''
	[UserType]$UserType = [UserType]::new()
}
