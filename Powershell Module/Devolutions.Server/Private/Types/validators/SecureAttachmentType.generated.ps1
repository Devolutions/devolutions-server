using namespace System.Management.Automation

class SecureAttachmentTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Password', 'PrivateConnection', 'PamCheckout', 'File', 'TemporaryAccessRequest')
	}
}
