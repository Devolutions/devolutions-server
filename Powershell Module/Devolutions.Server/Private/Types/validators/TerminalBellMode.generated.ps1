using namespace System.Management.Automation

class TerminalBellModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'None', 'Sound', 'Visual')
	}
}
