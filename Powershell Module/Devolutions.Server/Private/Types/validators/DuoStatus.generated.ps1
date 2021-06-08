using namespace System.Management.Automation

class DuoStatusValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('OK', 'InvalidOrMissingParameters', 'InvalidOrMissingParametersOrUsernameAlreadyExists', 'AuthorizationAndOrDateHeadersWereMissingOrInvalid', 'Error')
	}
}
