using namespace System.Management.Automation

class ConnectionDisplayModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('External', 'Embedded', 'Default', 'Unknown', 'Undocked')
	}
}
