using module '..\models\BaseCustomSecurity.generated.psm1'
using module '..\enums\OfflineMode.generated.psm1'
using module '..\enums\TimeBasedConnectionUsageDays.generated.psm1'
using module '..\enums\TimeBasedConnectionUsageHours.generated.psm1'
using module '..\enums\TlsOption.generated.psm1'

class CustomSecurity : BaseCustomSecurity 
{
	[boolean]$IsSimplifiedSecurity = $false
	[boolean]$AllowPersonalConnection = $true
	[String]$AzureADFederation = ''
	[boolean]$ContainedDatabaseUser = $false
	[OfflineMode]$OfflineMode = [OfflineMode]::new()
	[int]$SelectedDayOfWeek = 0
	[TimeBasedConnectionUsageDays]$TimeBasedUsageDays = [TimeBasedConnectionUsageDays]::new()
	[TimeBasedConnectionUsageHours]$TimeBasedUsageHours = [TimeBasedConnectionUsageHours]::new()
	[String]$TimeBasedUsageEndTime = ''
	[String]$TimeBasedUsageStartTime = ''
	[TlsOption]$TlsOption = [TlsOption]::new()
	[boolean]$DisableSqlUserManagement = $false
}
