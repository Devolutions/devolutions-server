using namespace System.Management.Automation

class SearchItemTypeValidator : IValidateSetValuesGenerator {
	[string[]] GetValidValues() {
		return ('Name', 'Folder', 'Username', 'Description', 'Tag')
	}
}
