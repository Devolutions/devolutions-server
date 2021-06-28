using namespace System.Management.Automation

class ServerUserTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Builtin', 'LocalWindows', 'SqlServer', 'Domain', 'Office365', 'None', 'Cloud', 'Legacy', 'AzureAD', 'Application')
	}
}
