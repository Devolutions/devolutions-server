using namespace System.Management.Automation

class WaykAccessControlValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Viewing', 'Interaction', 'Clipboard', 'FileTransfer', 'RemoteExecution', 'Chat')
	}
}
