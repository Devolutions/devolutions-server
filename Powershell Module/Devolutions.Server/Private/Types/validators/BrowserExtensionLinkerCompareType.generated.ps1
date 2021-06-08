using namespace System.Management.Automation

class BrowserExtensionLinkerCompareTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'BaseDomain', 'RegexDomain', 'RegexURL', 'Host', 'StartWith', 'Exact', 'Never')
	}
}
