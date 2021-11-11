using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryQuickFixEngineeringEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$Caption = ''
	[String]$CSName = ''
	[String]$Description = ''
	[String]$DeviceID = $null
	[String]$FixComments = ''
	[String]$FixStatus = ''
	[String]$HotFixIdentifier = ''
	[String]$ID = $null
	[String]$InstallDateTime = $null
	[String]$InstalledBy = ''
	[String]$InstalledOn = ''
	[String]$Name = ''
	[String]$ScanID = $null
	[String]$ServicePackInEffect = ''
	[String]$Status = ''
}
