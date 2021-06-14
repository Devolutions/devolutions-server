using namespace System.Management.Automation

class WaykDenSourceValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Cloud', 'Local', 'DataSource', 'Custom', 'Inherited')
	}
}
