using namespace System.Management.Automation

class UserTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Admin', 'User', 'Restricted', 'ReadOnly')
	}
}
