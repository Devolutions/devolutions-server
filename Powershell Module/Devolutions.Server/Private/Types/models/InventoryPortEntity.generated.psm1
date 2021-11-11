using module '..\models\InventoryEntity.generated.psm1'

class InventoryPortEntity : InventoryEntity 
{
	[String]$TableName = ''
	[String]$NetworkInterfaceID = $null
	[int]$Number = 0
	[String]$Protocol = ''
	[String]$Status = ''
}
