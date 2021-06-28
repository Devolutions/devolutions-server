using namespace System.Management.Automation

class OTPHashAlgorithmValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('SHA1', 'SHA256', 'SHA512')
	}
}
