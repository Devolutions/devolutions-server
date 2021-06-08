using namespace System.Management.Automation

class InventoryCredentialPriorityLevelValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Highest', 'High', 'Normal', 'Low', 'Lowest')
	}
}
