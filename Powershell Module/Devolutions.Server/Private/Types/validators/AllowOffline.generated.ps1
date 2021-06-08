using namespace System.Management.Automation

class AllowOfflineValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'True', 'False', 'Inherited')
	}
}
