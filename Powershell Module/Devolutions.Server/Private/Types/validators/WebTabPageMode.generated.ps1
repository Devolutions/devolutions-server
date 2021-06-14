using namespace System.Management.Automation

class WebTabPageModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Automatic', 'Always', 'Never')
	}
}
