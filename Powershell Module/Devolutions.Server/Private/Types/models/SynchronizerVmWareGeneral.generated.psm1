using module '..\models\SensitiveItem.generated.psm1'
using module '..\enums\VMWareConsoleType.generated.psm1'
using module '..\enums\VMWareSyncConnectionType.generated.psm1'
using module '..\enums\VMWareSyncMode.generated.psm1'

class SynchronizerVmWareGeneral
{
	[VMWareSyncConnectionType]$ConnectionType = [VMWareSyncConnectionType]::new()
	[VMWareConsoleType]$ConsoleType = [VMWareConsoleType]::new()
	[String]$DatacenterId = ''
	[String]$DatacenterName = ''
	[String]$Host = ''
	[SensitiveItem]$Password = [SensitiveItem]::new()
	[VMWareSyncMode]$SyncMode = [VMWareSyncMode]::new()
	[String]$Username = ''
}
