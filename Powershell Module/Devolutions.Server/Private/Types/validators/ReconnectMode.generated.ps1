using namespace System.Management.Automation

class ReconnectModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Full', 'SmartReconnect', 'Legacy')
	}
}
