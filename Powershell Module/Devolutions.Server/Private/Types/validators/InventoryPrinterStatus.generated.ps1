using namespace System.Management.Automation

class InventoryPrinterStatusValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Other', 'Unknown', 'Idle', 'Printing', 'Warmup', 'StoppedPrinting', 'Offline')
	}
}
