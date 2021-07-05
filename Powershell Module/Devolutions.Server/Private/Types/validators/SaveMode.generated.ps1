using namespace System.Management.Automation

class SaveModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Add', 'Edit', 'Delete', 'View')
	}
}
