using namespace System.Management.Automation

class ScreenColorValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('C256', 'C15Bits', 'C16Bits', 'C24Bits', 'C32Bits')
	}
}
