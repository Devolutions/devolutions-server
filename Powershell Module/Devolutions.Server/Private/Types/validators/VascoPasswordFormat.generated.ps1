using namespace System.Management.Automation

class VascoPasswordFormatValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('OTP', 'Static')
	}
}
