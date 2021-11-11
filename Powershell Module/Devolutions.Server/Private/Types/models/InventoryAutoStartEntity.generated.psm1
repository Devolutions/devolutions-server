using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryAutoStartEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$Command = ''
	[String]$DeviceID = $null
	[String]$ID = $null
	[String]$Location = ''
	[String]$Name = ''
	[String]$ScanID = $null
	[String]$User = ''
}
