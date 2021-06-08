using namespace System.Management.Automation

class ConnectionStateTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('CheckOut', 'LockEdit', 'Running')
	}
}
