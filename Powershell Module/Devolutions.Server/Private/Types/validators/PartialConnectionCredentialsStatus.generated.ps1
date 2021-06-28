using namespace System.Management.Automation

class PartialConnectionCredentialsStatusValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'NotFound', 'Prompt')
	}
}
