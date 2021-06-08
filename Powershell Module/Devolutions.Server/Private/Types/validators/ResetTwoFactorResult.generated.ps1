using namespace System.Management.Automation

class ResetTwoFactorResultValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('AlreadyReset', 'Reset', 'InvalidUserOrPassword', 'LockedUser', 'NotApprovedUser', 'InvalidIP')
	}
}
