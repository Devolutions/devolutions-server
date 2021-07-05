using namespace System.Management.Automation

class TerminalBackspaceKeyModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'ControlH', 'ControlQuestionMark')
	}
}
