using module '..\models\InventoryPortEntity.generated.psm1'

class InventoryNetworkInterfaceEntity
{
	[InventoryPortEntity]$Ports = [InventoryPortEntity]::new()
	[String]$DatabasePath = ''
	[String]$Description = ''
	[String]$DeviceID = $null
	[boolean]$DHCPEnabled = $false
	[String]$ID = $null
	[String]$IPAddress = ''
	[String]$IPAddressMac = ''
	[boolean]$IPEnabled = $false
	[String]$IPSubnet = ''
	[boolean]$IsAdapter = $false
	[String]$MACAddress = ''
	[String]$Name = ''
	[String]$ScanID = $null
}
