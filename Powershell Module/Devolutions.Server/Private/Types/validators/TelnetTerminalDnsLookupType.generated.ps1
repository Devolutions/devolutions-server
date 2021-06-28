using namespace System.Management.Automation

class TelnetTerminalDnsLookupTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Automatic', 'Yes', 'No')
	}
}
