using namespace System.Management.Automation

class AddEntryModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'TemplateListWithBlank', 'TemplateListOnly', 'NoTemplate')
	}
}
