using module '..\enums\ApplicationPlatform.generated.psm1'
using module '..\enums\ApplicationSource.generated.psm1'
using module '..\enums\LoginAttemptFailType.generated.psm1'

class LoginAttemptModel
{
	[String]$CreationDate = $null
	[LoginAttemptFailType]$FailType = [LoginAttemptFailType]::new()
	[String]$GravatarUrl = ''
	[String]$IP = ''
	[ApplicationPlatform]$Platform = [ApplicationPlatform]::new()
	[ApplicationSource]$Source = [ApplicationSource]::new()
	[String]$UserName = ''
}
