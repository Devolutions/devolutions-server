using namespace System.Management.Automation

class PasswordStrengthCalculatorValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Legacy', 'Zxcvbn', 'KeePass')
	}
}
