using namespace System.Management.Automation

class FtpSecurityTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('NoSecurity', 'ExplicitTLSorSSL', 'ImplicitTLSorSSL')
	}
}
