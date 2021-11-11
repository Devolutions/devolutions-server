using module '..\models\AccountInfoEntity.generated.psm1'
using module '..\enums\ServerUserType.generated.psm1'
using module '..\enums\UserLicenceTypeMode.generated.psm1'

class DPSAccountInfoEntity : AccountInfoEntity 
{
	[ServerUserType]$AuthenticationType = [ServerUserType]::new()
	[String]$DbId = ''
	[boolean]$HasLegacyPrivateVault = $false
	[boolean]$IsAdmin = $false
	[String]$UserId = $null
	[UserLicenceTypeMode]$UserLicenceType = [UserLicenceTypeMode]::new()
	[String]$DisplayName = ''
}
