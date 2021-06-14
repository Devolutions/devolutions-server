using namespace System.Management.Automation

class RequireCheckOutModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'True', 'False')
	}
}
