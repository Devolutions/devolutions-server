using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryMemoryEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$BankLabel = ''
	[String]$Capacity = ''
	[String]$Description = ''
	[String]$DeviceID = $null
	[String]$DeviceLocator = ''
	[int]$FormFactor = 0
	[String]$ID = $null
	[int]$InterleaveDataDepth = 0
	[int]$InterleavePosition = 0
	[String]$Manufacturer = ''
	[int]$MemoryType = 0
	[String]$Name = ''
	[String]$ScanID = $null
	[String]$SerialNumber = ''
	[String]$Speed = ''
}
