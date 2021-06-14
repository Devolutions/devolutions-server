using namespace System.Management.Automation

class SubscriptionProductTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Basic', 'Pro', 'Enterprise')
	}
}
