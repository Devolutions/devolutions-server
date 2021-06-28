using namespace System.Management.Automation

class ForbiddenPasswordUsageValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'None', 'Enabled', 'Inherited')
	}
}
