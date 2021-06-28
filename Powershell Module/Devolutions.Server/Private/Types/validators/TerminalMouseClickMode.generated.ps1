using namespace System.Management.Automation

class TerminalMouseClickModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Windows', 'Compromise', 'XTerm')
	}
}
