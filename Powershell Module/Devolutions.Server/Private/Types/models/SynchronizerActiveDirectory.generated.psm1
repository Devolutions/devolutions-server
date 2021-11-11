using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\models\SynchronizerActiveDirectoryAdvanced.generated.psm1'
using module '..\models\SynchronizerActiveDirectoryFilters.generated.psm1'
using module '..\models\SynchronizerActiveDirectoryGeneral.generated.psm1'
using module '..\models\SynchronizerActiveDirectoryLogin.generated.psm1'
using module '..\models\SynchronizerActiveDirectorySearch.generated.psm1'
using module '..\models\SynchronizerActiveDirectorySettings.generated.psm1'

class SynchronizerActiveDirectory : BaseSessionEntry 
{
	[SynchronizerActiveDirectoryGeneral]$General = [SynchronizerActiveDirectoryGeneral]::new()
	[SynchronizerActiveDirectorySettings]$Settings = [SynchronizerActiveDirectorySettings]::new()
	[SynchronizerActiveDirectoryLogin]$Login = [SynchronizerActiveDirectoryLogin]::new()
	[SynchronizerActiveDirectoryFilters]$Filters = [SynchronizerActiveDirectoryFilters]::new()
	[SynchronizerActiveDirectorySearch]$Search = [SynchronizerActiveDirectorySearch]::new()
	[SynchronizerActiveDirectoryAdvanced]$Advanced = [SynchronizerActiveDirectoryAdvanced]::new()
	[boolean]$ScheduleEnabled = $false
	[int]$ScheduledEveryXDays = 0
	[String]$ScheduledNextRunTimeUtc = $null
	[String]$ScheduledStartHourUtc = $null
}
