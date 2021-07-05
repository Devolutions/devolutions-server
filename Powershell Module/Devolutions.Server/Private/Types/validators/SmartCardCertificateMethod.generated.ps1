using namespace System.Management.Automation

class SmartCardCertificateMethodValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('CAPI', 'PKCS', 'Automatic')
	}
}
