using namespace System.Management.Automation

class CmdParamDataTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unused', 'Text', 'Secured')
	}
}
