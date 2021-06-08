using namespace System.Management.Automation

class DisplayVirtualDesktopValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Current', 'Default', 'First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'PromptOnConnection')
	}
}
