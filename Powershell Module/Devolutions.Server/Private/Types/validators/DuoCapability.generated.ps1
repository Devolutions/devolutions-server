using namespace System.Management.Automation

class DuoCapabilityValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Push', 'Phone', 'Sms')
	}
}
