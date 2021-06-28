using namespace System.Management.Automation

class CommandLineCaptureOutputModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'File')
	}
}
