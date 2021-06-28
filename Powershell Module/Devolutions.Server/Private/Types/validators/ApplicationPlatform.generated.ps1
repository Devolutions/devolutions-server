using namespace System.Management.Automation

class ApplicationPlatformValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Windows', 'Web', 'Mac', 'Android', 'IOS', 'Linux')
	}
}
