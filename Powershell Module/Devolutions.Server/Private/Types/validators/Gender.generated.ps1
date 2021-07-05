using namespace System.Management.Automation

class GenderValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unspecified', 'Male', 'Female')
	}
}
