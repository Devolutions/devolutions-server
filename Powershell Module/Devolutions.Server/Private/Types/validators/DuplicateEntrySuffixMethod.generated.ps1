using namespace System.Management.Automation

class DuplicateEntrySuffixMethodValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('TextSuffix', 'IncrementalSuffix')
	}
}
