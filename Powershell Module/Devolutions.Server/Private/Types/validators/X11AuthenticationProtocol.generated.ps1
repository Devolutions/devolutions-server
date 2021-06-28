using namespace System.Management.Automation

class X11AuthenticationProtocolValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'MITMagicCookie1', 'XDMAuthorization1')
	}
}
