using module '..\models\InventorySystemInformation.generated.psm1'

class InventoryHistoryEntity
{
	[InventorySystemInformation]$HostInfo = [InventorySystemInformation]::new()
	[String]$Data = ''
	[String]$DeviceID = $null
	[String]$ID = $null
	[String]$ReportDateTime = $null
	[String]$ScanID = $null
}
