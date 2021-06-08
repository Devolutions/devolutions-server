using namespace System.Management.Automation

class WaykQualityModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Low', 'Medium', 'High')
	}
}
