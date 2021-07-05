using namespace System.Management.Automation

class SessionRecordingTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unknown', 'WebM', 'TerminalPlayback')
	}
}
