using module '..\models\CustomSecurity.generated.psm1'
using module '..\enums\UserLicenceTypeMode.generated.psm1'
using module '..\enums\UserType.generated.psm1'

class UserInfoTemplate
{
	[String]$Culture = ''
	[CustomSecurity]$CustomSecurity = [CustomSecurity]::new()
	[boolean]$IsEmpty = $false
	[UserLicenceTypeMode]$UserLicenceType = [UserLicenceTypeMode]::new()
	[UserType]$UserType = [UserType]::new()
}
