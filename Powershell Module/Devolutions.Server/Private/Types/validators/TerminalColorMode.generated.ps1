using namespace System.Management.Automation

class TerminalColorModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Override')
	}
}
