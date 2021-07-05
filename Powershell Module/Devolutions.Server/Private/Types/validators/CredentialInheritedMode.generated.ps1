using namespace System.Management.Automation

class CredentialInheritedModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Parent', 'Folder')
	}
}
