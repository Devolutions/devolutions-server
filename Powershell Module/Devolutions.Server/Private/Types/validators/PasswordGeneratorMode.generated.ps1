using namespace System.Management.Automation

class PasswordGeneratorModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'SpecifiedSettings', 'HumanReadable', 'Pattern', 'Pronounceable', 'Strong')
	}
}
