using namespace System.Management.Automation

class TerminalCursorTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Block', 'Underline', 'VerticalLine')
	}
}
