using namespace System.Management.Automation

class TelnetTerminalProxyTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Socks4', 'Socks5', 'Http', 'Telnet', 'Local')
	}
}
