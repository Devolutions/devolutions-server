using namespace System.Management.Automation

class WaykRemoteExecutionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Run', 'Command', 'Process', 'ShellScript', 'BatchScript', 'PowerShell', 'AppleScript')
	}
}
