using namespace System.Management.Automation

class TerminalCursorKeyModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Normal', 'Application')
	}
}
