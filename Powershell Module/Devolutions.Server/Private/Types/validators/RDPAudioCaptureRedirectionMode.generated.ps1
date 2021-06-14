using namespace System.Management.Automation

class RDPAudioCaptureRedirectionModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('DoNotRecord', 'RecordFromThisComputer')
	}
}
