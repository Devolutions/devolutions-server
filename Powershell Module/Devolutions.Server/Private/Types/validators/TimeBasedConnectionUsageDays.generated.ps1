using namespace System.Management.Automation

class TimeBasedConnectionUsageDaysValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'AnyDay', 'Datasource', 'Inherited', 'WeekDays', 'WeekEnds', 'Custom')
	}
}
