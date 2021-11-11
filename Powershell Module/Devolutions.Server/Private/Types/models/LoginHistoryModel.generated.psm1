using module '..\enums\ApplicationPlatform.generated.psm1'
using module '..\enums\ApplicationSource.generated.psm1'
using module '..\enums\LoginAttemptFailType.generated.psm1'

class LoginHistoryModel
{
	[String]$CreationDate = $null
	[String]$ExpirationDate = $null
	[LoginAttemptFailType]$FailType = [LoginAttemptFailType]::new()
	[String]$GravatarUrl = ''
	[String]$Ip = ''
	[String]$LastUpdateDate = $null
	[ApplicationPlatform]$Platform = [ApplicationPlatform]::new()
	[String]$SessionHash = ''
	[ApplicationSource]$Source = [ApplicationSource]::new()
	[String]$UserName = ''
}
