using namespace System.Management.Automation

class MicrosoftHyperVConnectionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Console', 'ByName', 'ByID')
	}
}
