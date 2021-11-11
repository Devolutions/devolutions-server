using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryKeyboardEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$Description = ''
	[String]$DeviceID = $null
	[String]$ID = $null
	[String]$Name = ''
	[String]$ScanID = $null
}
