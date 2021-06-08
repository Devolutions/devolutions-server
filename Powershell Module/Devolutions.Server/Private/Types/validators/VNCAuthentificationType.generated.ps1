using namespace System.Management.Automation

class VNCAuthentificationTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Ard', 'ArdAskObserve', 'ArdAskControl', 'Invalid', 'MsLogon', 'None', 'Ultra', 'Vnc')
	}
}
