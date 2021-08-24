class ConnectionInfoEntity {
	[string[]]$CachedSecurityGroups
	[string[]]$SplittedGroupMain
	[int]$AttachmentCount
	[int]$AttachmentPrivateCount
	[ConnectionType]$ConnectionType
	[ConnectionType]$ConnectionSubType
	[String]$ConnexionTypeIcon
	[String]$ConnexionTypeString
	[String]$Data
	[String]$Group
	[String]$GroupMain
	[string[]]$Groups
	[int]$HandbookCount
	[String]$ID
	[IntelligentCacheAction]$IntelligentCacheAction
	[int]$InventoryReportCount
	[boolean]$IsPrivate
	[ConnectionMetaDataEntity]$MetaData
	[String]$MetaDataString
	[String]$Name
	[String]$RepositoryID
	[String]$SecurityGroup
	[int]$TodoOpenCount
	[String]$Version

	ConnectionInfoEntity() {
		$this.ConnectionType = [ConnectionType]::Undefined
		$this.ConnectionSubType = [ConnectionType]::Undefined
		$this.IntelligentCacheAction = [IntelligentCacheAction]::AddUpdate
		$this.MetaData = [ConnectionMetaDataEntity]::new()
	}
}
