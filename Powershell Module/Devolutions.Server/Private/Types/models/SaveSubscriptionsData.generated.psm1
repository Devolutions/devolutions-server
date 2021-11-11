using module '..\models\SubscriptionModel.generated.psm1'

class SaveSubscriptionsData
{
	[SubscriptionModel]$Subscriptions = [SubscriptionModel]::new()
}
