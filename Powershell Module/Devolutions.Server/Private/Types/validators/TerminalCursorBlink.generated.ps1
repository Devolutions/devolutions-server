using namespace System.Management.Automation

class TerminalCursorBlinkValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'On', 'Off')
	}
}
