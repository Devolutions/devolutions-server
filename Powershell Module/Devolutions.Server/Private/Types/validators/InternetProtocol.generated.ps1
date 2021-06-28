using namespace System.Management.Automation

class InternetProtocolValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'IPv4', 'IPv6')
	}
}
