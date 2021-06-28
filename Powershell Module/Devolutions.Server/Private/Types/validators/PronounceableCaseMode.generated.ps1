using namespace System.Management.Automation

class PronounceableCaseModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('LowerCase', 'UpperCase', 'MixedCase', 'RandomCase', 'RandomMixedCase')
	}
}
