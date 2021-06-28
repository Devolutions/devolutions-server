using namespace System.Management.Automation

class OTPCodeSizeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Six', 'Eight')
	}
}
