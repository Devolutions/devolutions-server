using module '..\enums\TimeBasedConnectionUsageDays.generated.psm1'
using module '..\enums\TimeBasedConnectionUsageHours.generated.psm1'

class TimeBasedUsageSettings
{
	[int]$SelectedDayOfWeek = 0
	[TimeBasedConnectionUsageDays]$TimeBasedUsageDays = [TimeBasedConnectionUsageDays]::new()
	[String]$TimeBasedUsageEndTime = ''
	[TimeBasedConnectionUsageHours]$TimeBasedUsageHours = [TimeBasedConnectionUsageHours]::new()
	[String]$TimeBasedUsageStartTime = ''
}
