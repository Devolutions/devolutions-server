using namespace System.Management.Automation

class RunAsCredentialSourceValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'CurrentSession', 'Custom', 'CredentialRepository', 'MyDefault', 'SameAsManagement')
	}
}
