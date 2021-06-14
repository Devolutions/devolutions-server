using namespace System.Management.Automation

class TerminalLogOverwriteModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Prompt', 'Append', 'Overwrite')
	}
}
