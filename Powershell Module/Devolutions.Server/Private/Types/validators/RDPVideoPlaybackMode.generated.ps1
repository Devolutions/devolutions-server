using namespace System.Management.Automation

class RDPVideoPlaybackModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Disabled', 'Default')
	}
}
