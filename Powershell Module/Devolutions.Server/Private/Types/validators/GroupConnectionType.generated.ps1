using namespace System.Management.Automation

class GroupConnectionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Folder', 'Site', 'Company', 'Workstation', 'Server', 'Device', 'Identity', 'Customer', 'Database', 'Printer', 'Domain', 'Software')
	}
}
