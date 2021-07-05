using namespace System.Management.Automation

class TemporaryAccessModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Inherited', 'Allowed', 'Denied')
	}
}
