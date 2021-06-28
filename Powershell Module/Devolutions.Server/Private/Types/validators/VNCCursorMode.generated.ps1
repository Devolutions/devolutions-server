using namespace System.Management.Automation

class VNCCursorModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('TrackLocally', 'RemoteDeal', 'DontShowRemote')
	}
}
