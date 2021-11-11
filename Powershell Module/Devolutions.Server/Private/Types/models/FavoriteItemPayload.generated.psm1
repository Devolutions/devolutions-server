using module '..\models\BaseConnectionInfo.generated.psm1'

class FavoriteItemPayload : BaseConnectionInfo 
{
	[boolean]$IsPrivate = $false
}
