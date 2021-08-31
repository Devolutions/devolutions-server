class ConnectionMetaDataEntity {
	[BrowserExtensionMetaData]$BrowserExtensionMetaData
	[String]$ConnectionMasterSubType
	[String]$ConnectionSubType
	[ConnectionType]$ConnectionType
	[DataSourcePermission]$DataSourcePermissions
	[String]$Description
	[String]$Expiration
	[String]$Group
	[String]$GroupMain
	[string[]]$Groups
	[String]$Host
	[String]$Image
	[String]$ImageName
	[boolean]$IsEmpty
	[String]$Keywords
	[String]$Name
	[SecurityConnection]$Security
	[boolean]$SharedTemplate
	[int]$SortPriority
	[String]$Status
	[String]$StatusMessage
	[String]$Url

	ConnectionMetaDataEntity() {
		$this.BrowserExtensionMetaData = [BrowserExtensionMetaData]::new()
		$this.DataSourcePermissions = [DataSourcePermission]::new()
		$this.Security = [SecurityConnection]::new()
	}
}
