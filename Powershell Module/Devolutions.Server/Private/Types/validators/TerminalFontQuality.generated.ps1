using namespace System.Management.Automation

class TerminalFontQualityValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'AntiAliased', 'NonAntiAliased', 'ClearType')
	}
}
