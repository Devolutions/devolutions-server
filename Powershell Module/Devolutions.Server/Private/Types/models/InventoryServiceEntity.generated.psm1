using module '..\models\InventoryGenericEntity.generated.psm1'

class InventoryServiceEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[String]$AcceptPause = ''
	[String]$AcceptStop = ''
	[String]$Caption = ''
	[int]$CheckPoint = 0
	[String]$CreationClassName = ''
	[String]$Description = ''
	[String]$DesktopInteract = ''
	[String]$DeviceID = $null
	[String]$DisplayName = ''
	[String]$ErrorControl = ''
	[int]$ExitCode = 0
	[String]$ID = $null
	[String]$InstallDate = ''
	[String]$Name = ''
	[String]$PathName = ''
	[int]$ProcessId = 0
	[String]$ScanID = $null
	[int]$ServiceSpecificExitCode = 0
	[String]$ServiceType = ''
	[String]$Started = ''
	[String]$StartMode = ''
	[String]$StartName = ''
	[String]$State = ''
	[String]$Status = ''
	[String]$SystemCreationClassName = ''
	[String]$SystemName = ''
	[int]$TagId = 0
	[int]$WaitHint = 0
}
