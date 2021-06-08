using namespace System.Management.Automation

class TerminalMinimumDiffieHellmanKeySizeModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Custom')
	}
}
