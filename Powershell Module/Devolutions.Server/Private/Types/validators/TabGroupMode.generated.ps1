using namespace System.Management.Automation

class TabGroupModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Custom', 'Inherited')
	}
}
