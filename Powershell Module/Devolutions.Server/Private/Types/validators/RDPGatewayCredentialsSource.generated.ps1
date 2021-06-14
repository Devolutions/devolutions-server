using namespace System.Management.Automation

class RDPGatewayCredentialsSourceValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('UserPassword', 'Smartcard', 'AskMeLater', 'GatewayAccessToken')
	}
}
