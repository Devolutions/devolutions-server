using namespace System.Management.Automation

class TwoFactorAuthenticationTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'GoogleAuthenticator', 'Yubikey', 'Email', 'Sms', 'Duo', 'SafeNet', 'AuthAnvil', 'AzureMFA', 'Radius', 'VascoSoap')
	}
}
