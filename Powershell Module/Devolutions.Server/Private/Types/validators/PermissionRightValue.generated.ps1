using namespace System.Management.Automation

class PermissionRightValueValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Denied', 'Allow', 'None')
	}
}
