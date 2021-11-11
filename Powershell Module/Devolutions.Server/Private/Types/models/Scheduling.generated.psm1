using module '..\enums\DayOfWeek.generated.psm1'
using module '..\enums\RecurrenceMode.generated.psm1'
using module '..\enums\RecurrencePosition.generated.psm1'

class Scheduling
{
	[DayOfWeek]$DayOfWeek = [DayOfWeek]::new()
	[DayOfWeek]$DaysOfWeek = [DayOfWeek]::new()
	[int]$EndAfterXOccurrences = $null
	[String]$EndDate = $null
	[int]$EveryX = 0
	[RecurrenceMode]$Mode = [RecurrenceMode]::new()
	[RecurrencePosition]$Position = [RecurrencePosition]::new()
	[String]$StartDateTimeUtc = $null
}
