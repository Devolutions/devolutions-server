using namespace System.Management.Automation

class SaveResultValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Error', 'Success', 'AccessDenied', 'InvalidData', 'AlreadyExists', 'MaximumReached', 'NotFound', 'LicenseExpired', 'Unknown', 'TwoFactorTypeNotConfigured', 'WebApiRedirectToLogin', 'DuplicateLoginEmail')
	}
}
