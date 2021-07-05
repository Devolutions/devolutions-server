using namespace System.Management.Automation

class VNCConfigValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('CustomConfiguration', 'ConfigFilename')
	}
}
