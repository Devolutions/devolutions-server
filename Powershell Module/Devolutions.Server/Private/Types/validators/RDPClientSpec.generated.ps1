using namespace System.Management.Automation

class RDPClientSpecValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'FullMode', 'ThinClientMode', 'SmallCacheMode')
	}
}
