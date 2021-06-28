using namespace System.Management.Automation

class ConnectionStatusFilterValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('ShowAll', 'Default', 'Locked', 'Disabled', 'Warning', 'Expired')
	}
}
