using namespace System.Management.Automation

class LogMessageTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Info', 'Warning', 'Debug', 'Error', 'ErrorSilent', 'Validation')
	}
}
