using namespace System.Management.Automation

class PasswordPwnedUsageValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'None', 'Enabled', 'Inherited', 'Required')
	}
}
