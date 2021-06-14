using namespace System.Management.Automation

class HandbookTemplateTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Tutorial', 'Empty', 'Custom')
	}
}
