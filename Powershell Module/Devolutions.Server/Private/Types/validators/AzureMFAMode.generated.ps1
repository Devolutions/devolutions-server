using namespace System.Management.Automation

class AzureMFAModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Sms', 'PhoneCall')
	}
}
