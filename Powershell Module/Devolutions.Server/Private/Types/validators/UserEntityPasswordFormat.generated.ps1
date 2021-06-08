using namespace System.Management.Automation

class UserEntityPasswordFormatValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Legacy', 'IdentityV2', 'IdentityV3')
	}
}
