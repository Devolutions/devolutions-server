using namespace System.Management.Automation

class DocumentDataModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Link', 'EmbeddedInConnection', 'EmbeddedInAttachment', 'Url')
	}
}
