using namespace System.Management.Automation

class PasswordPwnedResultValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Success', 'Failure', 'Timeout', 'UnknownError')
	}
}
