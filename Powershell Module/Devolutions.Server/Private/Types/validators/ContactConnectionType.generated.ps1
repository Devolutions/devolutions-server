using namespace System.Management.Automation

class ContactConnectionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Employee', 'Customer', 'Company', 'Supplier', 'Familly', 'Support')
	}
}
