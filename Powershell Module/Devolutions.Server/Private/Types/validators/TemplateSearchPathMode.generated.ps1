using namespace System.Management.Automation

class TemplateSearchPathModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'None', 'List', 'Inherited')
	}
}
