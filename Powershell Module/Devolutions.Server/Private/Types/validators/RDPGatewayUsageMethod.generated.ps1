using namespace System.Management.Automation

class RDPGatewayUsageMethodValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('ProxyModeNoneDirect', 'ModeDirect', 'ProxyModeDetect', 'ProxyModeDefault', 'NoneDetect')
	}
}
