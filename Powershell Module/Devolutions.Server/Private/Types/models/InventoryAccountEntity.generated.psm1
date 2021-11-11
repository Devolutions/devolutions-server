using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryAccountEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$Caption = ''
	[String]$ClassName = ''
	[String]$Description = ''
	[String]$DeviceID = $null
	[String]$Domain = ''
	[String]$ID = $null
	[String]$InstallDateTime = $null
	[boolean]$LocalAccount = $false
	[String]$Name = ''
	[String]$ScanID = $null
	[String]$SID = ''
	[int]$SIDType = 0
	[String]$Status = ''
}
