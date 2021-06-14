using namespace System.Management.Automation

class TelnetFunctionKeysModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('CommonExtended', 'Common', 'Linux', 'XtermR6', 'VT400', 'VT100Plus', 'Sco', 'CommonAlternative', 'VT52', 'LinuxAlternative', 'ScoAlternative', 'Wyse60', 'HpUx', 'Pick')
	}
}
