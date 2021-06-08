using namespace System.Management.Automation

class RadminConfigurationValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Configuration', 'ConfigFilename')
	}
}
