using module '..\models\FavoriteItemPayload.generated.psm1'

class FavoriteFolder
{
	[FavoriteItemPayload]$BaseConnectionInfos = [FavoriteItemPayload]::new()
	[String]$Name = ''
	[String]$PrevName = ''
}
