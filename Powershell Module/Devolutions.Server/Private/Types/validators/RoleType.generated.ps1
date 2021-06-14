using namespace System.Management.Automation

class RoleTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('ActiveDirectory', 'Custom', 'Office365')
	}
}
