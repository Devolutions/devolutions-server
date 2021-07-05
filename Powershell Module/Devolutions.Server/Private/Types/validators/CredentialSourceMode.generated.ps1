using namespace System.Management.Automation

class CredentialSourceModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('SessionSpecific', 'CredentialEntry', 'Embedded', 'Parent', 'Inherited', 'MyDefault', 'Personal', 'None', 'Prompt', 'CurrentSession', 'SameAsManagement', 'PrivateVaultSearch', 'SpecifyAtExecution', 'PrivilegedAccount')
	}
}
