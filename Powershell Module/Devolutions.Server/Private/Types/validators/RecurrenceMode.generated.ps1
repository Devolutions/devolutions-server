using namespace System.Management.Automation

class RecurrenceModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Hourly', 'EveryXDay', 'EveryWeekDay', 'EveryXWeek', 'EveryXWeekOnSelectedDays', 'EveryXMonthOnDay', 'EveryXMonthOnDayOfWeek', 'EveryXYearOnMonthDay', 'EveryXYearOnDayOfWeekMonth')
	}
}
