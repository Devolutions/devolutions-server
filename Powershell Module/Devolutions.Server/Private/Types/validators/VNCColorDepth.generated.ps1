using namespace System.Management.Automation

class VNCColorDepthValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('CFull', 'C8Bit', 'C256', 'C64', 'C8', 'C8Grey', 'C4Grey', 'C2Grey')
	}
}
