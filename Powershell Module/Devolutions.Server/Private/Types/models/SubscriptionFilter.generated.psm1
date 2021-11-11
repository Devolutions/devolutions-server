using module '..\enums\EventSubscriptionType.generated.psm1'

class SubscriptionFilter
{
	[String]$FilterId = $null
	[EventSubscriptionType]$SubscriptionType = [EventSubscriptionType]::new()
}
