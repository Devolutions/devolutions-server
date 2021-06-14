using namespace System.Management.Automation

class TerminalLocalEchoValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Auto', 'On', 'Off')
	}
}
