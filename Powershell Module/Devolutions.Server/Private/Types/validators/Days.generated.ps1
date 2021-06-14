using namespace System.Management.Automation

class DaysValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')
	}
}
