using namespace System.Management.Automation

class RecurrencePositionValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('First', 'Second', 'Third', 'Fourth', 'Last')
	}
}
