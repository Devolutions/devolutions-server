using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryDriveEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[boolean]$Compressed = $false
	[String]$Description = ''
	[String]$DeviceID = $null
	[int]$DriveType = 0
	[String]$DriveTypeMac = ''
	[String]$FileSystem = ''
	[int]$FreeSpace = 0
	[String]$ID = $null
	[boolean]$IsBootVolume = $false
	[int]$MaximumComponentLength = 0
	[String]$Name = ''
	[String]$ScanID = $null
	[int]$Size = 0
	[boolean]$SupportsDiskQuotas = $false
	[boolean]$SupportsFileBasedCompression = $false
	[boolean]$VolumeDirty = $false
	[String]$VolumeSerialNumber = ''
}
