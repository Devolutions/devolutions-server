using namespace System.Management.Automation

class UserLicenceTypeModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'ConnectionManagement', 'PasswordManagement')
	}
}
