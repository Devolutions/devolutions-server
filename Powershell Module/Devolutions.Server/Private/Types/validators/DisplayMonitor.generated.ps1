using namespace System.Management.Automation

class DisplayMonitorValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Primary', 'Secondary', 'Current', 'Configured', 'Default', 'First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'PromptOnConnection')
	}
}
