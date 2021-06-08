using namespace System.Management.Automation

class CheckOutCommentModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'True', 'False', 'Inherited')
	}
}
