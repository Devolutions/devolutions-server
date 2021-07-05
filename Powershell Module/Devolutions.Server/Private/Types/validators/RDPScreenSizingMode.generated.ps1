using namespace System.Management.Automation

class RDPScreenSizingModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'AutoScale', 'FitToWindow', 'Server', 'None', 'Scrollbar')
	}
}
