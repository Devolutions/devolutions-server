using namespace System.Management.Automation

class TerminalKeypadModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Enable', 'Disable')
	}
}
