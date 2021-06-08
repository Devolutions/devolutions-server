using namespace System.Management.Automation

class WaykAuthTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'PromptForPermission', 'SecureRemotePassword', 'SecureRemoteDelegation', 'Ntlm')
	}
}
