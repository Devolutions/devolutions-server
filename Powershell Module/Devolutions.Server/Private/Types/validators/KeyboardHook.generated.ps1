using namespace System.Management.Automation

class KeyboardHookValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('OnTheLocalComputer', 'OnTheRemoteComputer', 'InFullScreenMode', 'Default')
	}
}
