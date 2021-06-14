using namespace System.Management.Automation

class TerminalDisconnectActionValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Close', 'KeepOpen', 'Reconnect')
	}
}
