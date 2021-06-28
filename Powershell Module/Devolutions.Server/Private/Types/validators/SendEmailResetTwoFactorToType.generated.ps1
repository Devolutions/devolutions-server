using namespace System.Management.Automation

class SendEmailResetTwoFactorToTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Administrators', 'SpecificEmail')
	}
}
