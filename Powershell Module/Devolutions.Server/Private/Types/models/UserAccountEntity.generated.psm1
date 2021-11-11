using module '..\models\TwoFactorInfo.generated.psm1'
using module '..\enums\UserEntityPasswordFormat.generated.psm1'

class UserAccountEntity
{
	[boolean]$HasPrivateVault = $false
	[boolean]$HasSpecificSettings = $false
	[boolean]$IsChangePasswordAllowed = $false
	[String]$Password = ''
	[UserEntityPasswordFormat]$PasswordFormat = [UserEntityPasswordFormat]::new()
	[TwoFactorInfo]$TwoFactorInfo = [TwoFactorInfo]::new()
	[String]$ConnectionOverrides = ''
	[String]$ConnectionOverridesCacheID = ''
	[String]$CreatedByLoggedUserName = ''
	[String]$CreatedByUserName = ''
	[String]$CreationDate = $null
	[String]$Data = ''
	[String]$Email = ''
	[String]$FullName = ''
	[String]$ID = $null
	[boolean]$IsOwner = $false
	[boolean]$IsTemplate = $false
	[String]$LastLoginDate = $null
	[String]$ModifiedDate = $null
	[String]$ModifiedLoggedUserName = ''
	[String]$ModifiedUserName = ''
	[boolean]$ResetTwoFactor = $false
	[String]$SecurityKey = ''
	[boolean]$UserMustChangePasswordAtNextLogon = $false
}
