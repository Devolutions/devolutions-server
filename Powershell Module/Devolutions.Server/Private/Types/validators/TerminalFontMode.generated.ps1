using namespace System.Management.Automation

class TerminalFontModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Override')
	}
}
