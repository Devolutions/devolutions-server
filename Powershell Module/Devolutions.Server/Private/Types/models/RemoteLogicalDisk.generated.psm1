
class RemoteLogicalDisk
{
	[boolean]$Compressed = $false
	[String]$Description = ''
	[int]$DriveType = 0
	[String]$DriveTypeMac = ''
	[String]$FileSystem = ''
	[int]$FreeSpace = 0
	[String]$FreeSpacePercentage = ''
	[boolean]$IsBootVolume = $false
	[int]$MaximumComponentLength = 0
	[String]$Name = ''
	[int]$Size = 0
	[boolean]$SupportsDiskQuotas = $false
	[boolean]$SupportsFileBasedCompression = $false
	[boolean]$VolumeDirty = $false
	[String]$VolumeSerialNumber = ''
}
