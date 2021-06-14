using namespace System.Management.Automation

class ConnectionStatusBehaviorValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Locked', 'Disabled', 'Warning', 'Expired')
	}
}
