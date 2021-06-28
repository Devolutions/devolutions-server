using namespace System.Management.Automation

class SIDTypesValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'User', 'Group', 'Domain', 'Alias', 'WellKnownGroup', 'DeletedAccount', 'Invalid', 'Unknown', 'Computer')
	}
}
