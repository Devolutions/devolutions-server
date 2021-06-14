using namespace System.Management.Automation

class RDPLogOffMethodValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Automatic', 'RDMAgent', 'WMI', 'Macro')
	}
}
