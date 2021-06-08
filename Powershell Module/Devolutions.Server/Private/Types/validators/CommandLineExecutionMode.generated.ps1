using namespace System.Management.Automation

class CommandLineExecutionModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'KeepOpen', 'Capture')
	}
}
