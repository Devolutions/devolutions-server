using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\models\SynchronizerVmWareAdvanced.generated.psm1'
using module '..\models\SynchronizerVmWareGeneral.generated.psm1'
using module '..\models\SynchronizerVmWareSettings.generated.psm1'

class SynchronizerVmWare : BaseSessionEntry 
{
	[SynchronizerVmWareAdvanced]$Advanced = [SynchronizerVmWareAdvanced]::new()
	[SynchronizerVmWareGeneral]$General = [SynchronizerVmWareGeneral]::new()
	[SynchronizerVmWareSettings]$Settings = [SynchronizerVmWareSettings]::new()
	[boolean]$ScheduleEnabled = $false
	[int]$ScheduledEveryXDays = 0
	[String]$ScheduledNextRunTimeUtc = $null
	[String]$ScheduledStartHourUtc = $null
}
