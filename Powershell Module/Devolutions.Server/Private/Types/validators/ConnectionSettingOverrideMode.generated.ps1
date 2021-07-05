using namespace System.Management.Automation

class ConnectionSettingOverrideModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Local', 'User', 'Both')
	}
}
