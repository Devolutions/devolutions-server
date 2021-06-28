using namespace System.Management.Automation

class ProxyTunnelTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Http', 'Socks4', 'Socks4A', 'Socks5')
	}
}
