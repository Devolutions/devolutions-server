using namespace System.Management.Automation

class VNCSelectDisplayModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Primary', 'Custom', 'Prompt')
	}
}
