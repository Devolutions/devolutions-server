using namespace System.Management.Automation

class DateTimeFormatModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'US', 'Custom')
	}
}
