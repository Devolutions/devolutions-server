using namespace System.Management.Automation

class PasswordComplexityUsageValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'None', 'Enabled', 'EnabledWarning', 'Inherited')
	}
}
