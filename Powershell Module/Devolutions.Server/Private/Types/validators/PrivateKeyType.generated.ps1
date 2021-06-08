using namespace System.Management.Automation

class PrivateKeyTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('NoKey', 'File', 'Data', 'Link', 'MyDefault', 'PrivateVault', 'UserVaultSearchString')
	}
}
