using namespace System.Management.Automation

class ToolCredentialSourceValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'CurrentSession', 'Custom', 'CredentialRepository', 'MyDefault', 'SameAsManagement', 'Personal', 'Inherited', 'Prompt', 'SpecifyAtExecution', 'PrivilegedAccount', 'PrivateVaultSearch')
	}
}
