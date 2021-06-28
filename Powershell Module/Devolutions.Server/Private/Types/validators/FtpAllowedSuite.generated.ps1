using namespace System.Management.Automation

class FtpAllowedSuiteValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('AllCiphers', 'SecureOnly')
	}
}
