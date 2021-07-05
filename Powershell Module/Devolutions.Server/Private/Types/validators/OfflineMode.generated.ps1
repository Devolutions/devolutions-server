using namespace System.Management.Automation

class OfflineModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Disabled', 'Cache', 'ReadOnly', 'ReadWrite', 'Unknown')
	}
}
