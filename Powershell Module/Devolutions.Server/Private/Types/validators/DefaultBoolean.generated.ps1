using namespace System.Management.Automation

class DefaultBooleanValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'True', 'False')
	}
}
