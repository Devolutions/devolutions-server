using namespace System.Management.Automation

class TlsOptionValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('NotSpecified', 'None', 'Ssl', 'X509')
	}
}
