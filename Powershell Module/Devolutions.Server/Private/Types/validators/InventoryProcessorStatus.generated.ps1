using namespace System.Management.Automation

class InventoryProcessorStatusValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unknown', 'CPUEnabled', 'CPUDisabledByUserviaBIOSSetup', 'CPUDisabledByBIOSPOSTError', 'CPUIsIdle', 'Reserved', 'Reserved1', 'Other')
	}
}
