using namespace System.Management.Automation

class DocumentConnectionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Word', 'Excel', 'PowerPoint', 'Image', 'Visio', 'OneNote', 'PDF', 'Certificate', 'Text', 'PhoneBook', 'PrivateKey', 'Email', 'Spreadsheet', 'RichText', 'Video', 'Html', 'HtmlEditor', 'DataSourceConfiguration', 'TextPlain', 'TextEditor')
	}
}
