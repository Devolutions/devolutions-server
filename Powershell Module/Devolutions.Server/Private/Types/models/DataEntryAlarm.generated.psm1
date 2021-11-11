using module '..\models\DataEntryAlarmValueItem.generated.psm1'

class DataEntryAlarm
{
	[DataEntryAlarmValueItem]$Alarms = [DataEntryAlarmValueItem]::new()
	[String]$Url = ''
}
