using namespace System.Management.Automation

class WaykExecTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Run', 'Command', 'Process', 'BatchScript', 'PowerShell')
	}
}
