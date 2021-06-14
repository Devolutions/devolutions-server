using namespace System.Management.Automation

class TwoFactorUsageTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Optional', 'Required')
	}
}
