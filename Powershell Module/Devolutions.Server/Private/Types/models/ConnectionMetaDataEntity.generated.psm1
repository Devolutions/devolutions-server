using module '..\models\BrowserExtensionMetaData.generated.psm1'
using module '..\enums\ConnectionType.generated.psm1'
using module '..\models\DataSourcePermission.generated.psm1'
using module '..\models\SecurityConnection.generated.psm1'

class ConnectionMetaDataEntity
{
	[BrowserExtensionMetaData]$BrowserExtensionMetaData = [BrowserExtensionMetaData]::new()
	[String]$ConnectionMasterSubType = ''
	[String]$ConnectionSubType = ''
	[ConnectionType]$ConnectionType = [ConnectionType]::new()
	[DataSourcePermission]$DataSourcePermissions = [DataSourcePermission]::new()
	[String]$Description = ''
	[String]$Expiration = $null
	[String]$Group = ''
	[String]$GroupMain = ''
	[string[]]$Groups = @()
	[String]$Host = ''
	[String]$Image = $null
	[String]$ImageName = ''
	[boolean]$IsEmpty = $false
	[String]$Keywords = ''
	[String]$Name = ''
	[SecurityConnection]$Security = [SecurityConnection]::new()
	[boolean]$SharedTemplate = $false
	[int]$SortPriority = 0
	[String]$Status = ''
	[String]$StatusMessage = ''
	[String]$Url = ''
}
