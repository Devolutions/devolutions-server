using module '..\models\InventoryGenericEntity.generated.psm1'

class InventorySimpleDeviceEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$DeviceID = $null
	[String]$ID = $null
	[String]$Name = ''
	[String]$ScanID = $null
}
