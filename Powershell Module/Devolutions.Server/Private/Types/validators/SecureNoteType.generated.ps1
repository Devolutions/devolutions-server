using namespace System.Management.Automation

class SecureNoteTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Rtf', 'Text', 'Markdown')
	}
}
