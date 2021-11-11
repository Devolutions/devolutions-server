using module '..\models\InventoryGenericEntity.generated.psm1'

class InventorySoundAdapterEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$DeviceID = $null
	[int]$DMABufferSize = 0
	[String]$ID = $null
	[String]$Manufacturer = ''
	[String]$Name = ''
	[String]$ScanID = $null
}
