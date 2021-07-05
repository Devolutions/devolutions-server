using namespace System.Management.Automation

class TerminalFunctionKeysModeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'EscN', 'Linux', 'XtermR6', 'VT400', 'VT100Plus', 'SCO', 'Common', 'Alternative', 'HpUx', 'Linux220', 'LinuxAlternative', 'Pick', 'VT52', 'Wyse', 'Xterm')
	}
}
