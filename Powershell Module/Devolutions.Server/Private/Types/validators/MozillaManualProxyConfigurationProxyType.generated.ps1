using namespace System.Management.Automation

class MozillaManualProxyConfigurationProxyTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Http', 'Ftp', 'Socks', 'Ssl')
	}
}
