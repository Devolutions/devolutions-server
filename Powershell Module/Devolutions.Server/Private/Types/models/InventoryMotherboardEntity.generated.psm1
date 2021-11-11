using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryMotherboardEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$DeviceID = $null
	[String]$ID = $null
	[String]$Manufacturer = ''
	[String]$Model = ''
	[String]$Name = ''
	[String]$Product = ''
	[String]$ScanID = $null
	[String]$SerialNumber = ''
	[String]$Version = ''
}
