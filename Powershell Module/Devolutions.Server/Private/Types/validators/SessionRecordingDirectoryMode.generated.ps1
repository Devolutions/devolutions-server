using namespace System.Management.Automation

class SessionRecordingDirectoryModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Inherited', 'Custom', 'Root')
	}
}
