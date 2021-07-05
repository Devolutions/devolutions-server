using namespace System.Management.Automation

class ChromeProxyTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'None', 'Http', 'Https', 'Socks4', 'Socks4a', 'Socks5')
	}
}
