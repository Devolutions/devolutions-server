using namespace System.Management.Automation

class PasswordComplexityValidationValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Default', 'Warn', 'Required', 'Inherited')
	}
}
