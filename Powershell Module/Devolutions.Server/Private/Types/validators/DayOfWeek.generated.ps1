using namespace System.Management.Automation

class DayOfWeekValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')
	}
}
