using namespace System.Management.Automation

class SessionRecordingTargetValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Local', 'Remote', 'Inherited', 'Root')
	}
}
