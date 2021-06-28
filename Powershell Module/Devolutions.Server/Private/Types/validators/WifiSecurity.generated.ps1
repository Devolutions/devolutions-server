using namespace System.Management.Automation

class WifiSecurityValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'WEP', 'WPA', 'WPA2Personal', 'WPA2Enterprise')
	}
}
