using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryShareEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[boolean]$AllowMaximum = $false
	[String]$Caption = ''
	[String]$Description = ''
	[String]$DeviceID = $null
	[String]$ID = $null
	[int]$MaximumAllowed = 0
	[String]$Name = ''
	[String]$Path = ''
	[String]$ScanID = $null
	[String]$Status = ''
	[String]$Type = ''
}
