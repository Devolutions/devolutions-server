using module '..\models\LoginParameters.generated.psm1'
using module '..\models\TwoFactorInfo.generated.psm1'

class LoginData
{
	[LoginParameters]$LoginParameters = [LoginParameters]::new()
	[LoginParameters]$RDMOLoginParameters = [LoginParameters]::new()
	[TwoFactorInfo]$TwoFactorInfo = [TwoFactorInfo]::new()
	[String]$UserName = ''
}
