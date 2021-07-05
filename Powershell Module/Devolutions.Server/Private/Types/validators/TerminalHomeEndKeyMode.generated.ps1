using namespace System.Management.Automation

class TerminalHomeEndKeyModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Standard', 'Rxvt')
	}
}
