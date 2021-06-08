using namespace System.Management.Automation

class TerminalAutoWrapValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'On', 'Off')
	}
}
