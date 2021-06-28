using namespace System.Management.Automation

class RepositoryTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('DVLS', 'Asset')
	}
}
