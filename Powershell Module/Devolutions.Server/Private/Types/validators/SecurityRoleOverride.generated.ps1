using namespace System.Management.Automation

class SecurityRoleOverrideValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Custom', 'Inherited', 'Everyone', 'Never')
	}
}
