using namespace System.Management.Automation

class CredentialModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'None', 'SameAsManagement', 'SessionCredentials', 'PromptForCredentials', 'CustomCredentials', 'CredentialRepository', 'MyPersonalCredentials', 'PrivateVault', 'PrivateVaultSearch')
	}
}
