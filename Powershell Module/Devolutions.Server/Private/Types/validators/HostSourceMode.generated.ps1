using namespace System.Management.Automation

class HostSourceModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('SessionSpecific', 'HostEntry', 'Inherited', 'Prompt')
	}
}
