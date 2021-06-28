using namespace System.Management.Automation

class JumpTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'ParentConnection', 'Inherited', 'LinkedConnection', 'LinkedConnectionUserVault')
	}
}
