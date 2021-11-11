using module '..\models\ConnectionMetaDataEntity.generated.psm1'
using module '..\enums\ConnectionType.generated.psm1'
using module '..\enums\IntelligentCacheAction.generated.psm1'

class ConnectionInfoEntity
{
	[string[]]$CachedSecurityGroups = @()
	[string[]]$SplittedGroupMain = @()
	[int]$AttachmentCount = 0
	[int]$AttachmentPrivateCount = 0
	[ConnectionType]$ConnectionType = [ConnectionType]::new()
	[String]$ConnexionTypeIcon = ''
	[String]$ConnexionTypeString = ''
	[String]$Data = ''
	[String]$Group = ''
	[String]$GroupMain = ''
	[string[]]$Groups = @()
	[int]$HandbookCount = 0
	[String]$ID = $null
	[IntelligentCacheAction]$IntelligentCacheAction = [IntelligentCacheAction]::new()
	[int]$InventoryReportCount = 0
	[boolean]$IsPrivate = $false
	[ConnectionMetaDataEntity]$MetaData = [ConnectionMetaDataEntity]::new()
	[String]$MetaDataString = ''
	[String]$Name = ''
	[String]$RepositoryID = $null
	[String]$SecurityGroup = $null
	[int]$TodoOpenCount = 0
	[String]$Version = ''
}
