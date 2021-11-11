using module '..\enums\EventSubscriptionType.generated.psm1'
using module '..\enums\SaveMode.generated.psm1'

class SubscriptionModel
{
	[EventSubscriptionType]$EventSubscriptionType = [EventSubscriptionType]::new()
	[object]$FilterConfig = $null
	[String]$FilterID = $null
	[String]$ID = $null
	[boolean]$IsActive = $false
	[boolean]$IsAdd = $false
	[boolean]$IsDelete = $false
	[boolean]$IsEdit = $false
	[SaveMode]$SaveMode = [SaveMode]::new()
	[String]$UserID = $null
}
