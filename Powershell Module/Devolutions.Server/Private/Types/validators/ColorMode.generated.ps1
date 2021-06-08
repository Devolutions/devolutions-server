using namespace System.Management.Automation

class ColorModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Custom', 'Inherited')
	}
}
