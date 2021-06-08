using namespace System.Management.Automation

class PortForwardModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Local', 'Remote', 'Dynamic')
	}
}
