using namespace System.Management.Automation

class DateFilterValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('LastWeek', 'Today', 'Yesterday', 'Custom', 'LastMonth', 'CurrentMonth', 'Last7Days', 'Last30Days', 'Last31Days', 'Last60Days', 'Last90Days')
	}
}
