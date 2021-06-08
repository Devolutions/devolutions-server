using namespace System.Management.Automation

class WebBrowserApplicationValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'IE', 'FireFox', 'GoogleChrome', 'Safari', 'Opera', 'Edge')
	}
}
