using namespace System.Management.Automation

class SessionRecordingModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Enabled', 'Required', 'RequiredWhenAvailable', 'Never', 'Inherited', 'Root')
	}
}
