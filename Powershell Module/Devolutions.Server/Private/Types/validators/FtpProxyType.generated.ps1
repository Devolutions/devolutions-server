using namespace System.Management.Automation

class FtpProxyTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Socks4', 'Socks4a', 'Socks5', 'HttpConnect', 'FtpSite', 'FtpUser', 'FtpOpen')
	}
}
