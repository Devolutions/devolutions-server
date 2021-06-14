using namespace System.Management.Automation

class SessionToolConnectionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('CommandLine', 'PSExec', 'PowerShell', 'WMI', 'VBScript', 'Template', 'DatabaseQuery', 'PowerShellLocal', 'Macro', 'JitBit', 'WASPPowerShell', 'AutoIT', 'AutoHotKey', 'AppleScript', 'SSHCommandLine', 'ResetPassword', 'RemoteDeploy', 'Report')
	}
}
