using namespace System.Management.Automation

class SoundHookValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('BringToThisComputer', 'DoNotPlay', 'LeaveAtRemoteComputer', 'Default')
	}
}
