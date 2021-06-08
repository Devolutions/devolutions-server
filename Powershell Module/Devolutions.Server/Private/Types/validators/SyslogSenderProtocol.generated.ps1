using namespace System.Management.Automation

class SyslogSenderProtocolValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('TCP', 'UDP')
	}
}
