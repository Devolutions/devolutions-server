using namespace System.Management.Automation

class TerminalLogModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Event', 'AllPrintableOutput')
	}
}
