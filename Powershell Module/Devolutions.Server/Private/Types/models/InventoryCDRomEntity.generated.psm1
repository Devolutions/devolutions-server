using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryCDRomEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$Description = ''
	[String]$DeviceID = $null
	[String]$Drive = ''
	[String]$ID = $null
	[String]$Manufacturer = ''
	[boolean]$MediaLoaded = $false
	[String]$MediaType = ''
	[String]$Name = ''
	[String]$ScanID = $null
}
