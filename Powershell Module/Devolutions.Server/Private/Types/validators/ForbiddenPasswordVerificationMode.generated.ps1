using namespace System.Management.Automation

class ForbiddenPasswordVerificationModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Contains', 'Equals')
	}
}
