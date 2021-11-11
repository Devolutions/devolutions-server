using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryOSEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[int]$BuildNumber = 0
	[String]$CSDVersion = ''
	[String]$CSName = ''
	[String]$DeviceID = $null
	[int]$FreePhysicalMemory = 0
	[int]$FreeVirtualMemory = 0
	[String]$ID = $null
	[String]$InstallDateTime = $null
	[String]$LastBootUpDateTime = $null
	[String]$Locale = ''
	[String]$Manufacturer = ''
	[String]$Name = ''
	[int]$OSType = $null
	[String]$ScanID = $null
	[int]$ServicePackMajorVersion = 0
	[int]$ServicePackMinorVersion = 0
	[int]$SizeStoredInPagingFiles = 0
	[int]$TotalVirtualMemorySize = 0
	[int]$TotalVisibleMemorySize = 0
	[String]$Version = ''
	[String]$WindowsDirectory = ''
}
