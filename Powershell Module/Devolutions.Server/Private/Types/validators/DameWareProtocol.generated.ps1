using namespace System.Management.Automation

class DameWareProtocolValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('MRCViewer', 'RDPProtocol', 'VNCViewer')
	}
}
