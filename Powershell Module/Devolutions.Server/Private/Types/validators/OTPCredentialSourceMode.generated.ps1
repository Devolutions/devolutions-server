using namespace System.Management.Automation

class OTPCredentialSourceModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'CredentialRepository', 'PrivateVault', 'PrivateVaultSearch')
	}
}
