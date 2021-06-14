using namespace System.Management.Automation

class MozillaNetworkProxyTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('NoProxy', 'ManualProxyConfiguration', 'ProxyAutoConfiguration', 'AutoDetectProxySettings', 'UseSystemProxySettings', 'Default')
	}
}
