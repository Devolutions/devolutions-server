using namespace System.Management.Automation

class RDPTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Normal', 'Azure', 'HyperV')
	}
}
