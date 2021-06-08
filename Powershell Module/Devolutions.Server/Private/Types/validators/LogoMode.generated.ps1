using namespace System.Management.Automation

class LogoModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Url', 'File')
	}
}
