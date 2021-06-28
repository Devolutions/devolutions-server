using namespace System.Management.Automation

class TwoFactorValidationTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Success', 'Invalid', 'UserDeny', 'SecondStepIsRequired', 'ValidationCodeIsEmpty', 'SmsSended', 'Fraud', 'Timeout', 'Lockedout')
	}
}
