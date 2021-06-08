using namespace System.Management.Automation

class DataEntryWalletTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('DriverLicense', 'SocialSecurityNumber', 'Membership')
	}
}
