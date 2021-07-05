using namespace System.Management.Automation

class WaykFileTransferStateValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Completed', 'Active', 'Canceled', 'Paused')
	}
}
