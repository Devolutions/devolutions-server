using namespace System.Management.Automation

class TimeBasedConnectionUsageHoursValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'AnyTime', 'Datasource', 'Inherited', 'Custom')
	}
}
