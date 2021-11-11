using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryMonitorEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[int]$Availability = 0
	[int]$Bandwidth = 0
	[String]$DeviceID = $null
	[String]$ID = $null
	[String]$Manufacturer = ''
	[String]$Name = ''
	[String]$ScanID = $null
	[int]$ScreenHeight = 0
	[int]$ScreenWidth = 0
}
