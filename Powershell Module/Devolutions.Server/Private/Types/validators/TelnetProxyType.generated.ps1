using namespace System.Management.Automation

class TelnetProxyTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Socks4', 'Socks4a', 'Socks5', 'HttpConnect')
	}
}
