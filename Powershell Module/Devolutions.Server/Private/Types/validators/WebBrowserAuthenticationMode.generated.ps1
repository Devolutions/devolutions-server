using namespace System.Management.Automation

class WebBrowserAuthenticationModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Form', 'Basic', 'Digest', 'Ntlm')
	}
}
