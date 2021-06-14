using namespace System.Management.Automation

class VNCEmbeddedTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'UltraVNC')
	}
}
