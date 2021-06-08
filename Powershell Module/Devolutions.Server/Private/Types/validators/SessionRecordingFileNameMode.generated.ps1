using namespace System.Management.Automation

class SessionRecordingFileNameModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'ConnectionLogID', 'ConnectionName', 'DateTime', 'Custom', 'Root')
	}
}
