using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryBiosEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$Caption = ''
	[String]$DeviceID = $null
	[String]$ID = $null
	[String]$Manufacturer = ''
	[String]$ReleaseDateTime = $null
	[String]$ScanID = $null
	[String]$SerialNumber = ''
	[String]$SMBiosBiosVersion = ''
}
