using namespace System.Management.Automation

class PasswordQualityEstimatorValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'PopularPassword', 'Forbidden', 'VeryWeak', 'Weak', 'Good', 'Strong', 'VeryStrong', 'Perfect', 'Encrypted')
	}
}
