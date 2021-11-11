using module '..\models\InventoryEntity.generated.psm1'
using module '..\models\InventoryVideoInstalledDriverEntity.generated.psm1'

class InventoryVideoAdapterEntity : InventoryEntity 
{
	[InventoryVideoInstalledDriverEntity]$InstalledDrivers = [InventoryVideoInstalledDriverEntity]::new()
	[String]$TableName = ''
	[String]$AdapterCompatibility = ''
	[String]$AdapterDACType = ''
	[String]$AdapterRam = ''
	[int]$Availability = 0
	[String]$DeviceID = $null
	[String]$DriverVersion = ''
	[String]$ID = $null
	[String]$Manufacturer = ''
	[String]$Name = ''
	[int]$RefreshRate = 0
	[String]$ScanID = $null
	[String]$ScreenInfo = ''
	[String]$Status = ''
	[int]$VideoArchitecture = 0
	[int]$VideoMemoryType = 0
}
