using module '..\enums\SubscriptionProductType.generated.psm1'

class DataSourceInfoEntity
{
	[boolean]$AllowAttachments = $false
	[boolean]$AllowConnectionLogs = $false
	[boolean]$AllowSharing = $false
	[int]$AttachmentSize = 0
	[int]$ConnectionCount = 0
	[String]$CreationDate = $null
	[String]$Description = ''
	[String]$ID = $null
	[boolean]$IsDeleted = $false
	[boolean]$IsEnabled = $true
	[boolean]$IsExpired = $false
	[boolean]$IsTrial = $false
	[String]$License = ''
	[String]$LicenseExpiration = $null
	[int]$MaxAttachmentSize = 0
	[int]$MaxConnectionCount = 0
	[int]$MaxUserCount = 0
	[String]$Name = ''
	[SubscriptionProductType]$SubscriptionType = [SubscriptionProductType]::new()
	[int]$UserCount = 0
}
