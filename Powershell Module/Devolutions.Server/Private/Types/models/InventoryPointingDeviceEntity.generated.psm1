using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryPointingDeviceEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$Description = ''
	[String]$DeviceID = $null
	[String]$ID = $null
	[String]$Manufacturer = ''
	[String]$Name = ''
	[String]$ScanID = $null
}
