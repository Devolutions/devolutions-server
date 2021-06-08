using namespace System.Management.Automation

class CustomInstallerStatusValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Created', 'InProgress', 'Fail', 'Success')
	}
}
