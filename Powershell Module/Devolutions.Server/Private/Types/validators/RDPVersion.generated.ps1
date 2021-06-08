using namespace System.Management.Automation

class RDPVersionValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unknown', 'RDP50', 'RDP60', 'RDP61', 'RDP70', 'RDP80', 'RDP81', 'Default', 'FreeRDP', 'FreeRDP7')
	}
}
