using namespace System.Management.Automation

class CheckOutModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'NotSupported', 'Automatic', 'Manual', 'Inherited', 'Optional')
	}
}
