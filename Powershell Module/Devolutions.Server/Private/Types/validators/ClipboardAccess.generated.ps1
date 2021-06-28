using namespace System.Management.Automation

class ClipboardAccessValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Admin', 'Editor', 'All')
	}
}
