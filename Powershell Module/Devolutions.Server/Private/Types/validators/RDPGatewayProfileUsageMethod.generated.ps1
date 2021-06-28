using namespace System.Management.Automation

class RDPGatewayProfileUsageMethodValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Explicit')
	}
}
