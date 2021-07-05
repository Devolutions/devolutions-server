using namespace System.Management.Automation

class ARDSessionSelectRequestTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('AskToShare', 'Share', 'Virtual')
	}
}
