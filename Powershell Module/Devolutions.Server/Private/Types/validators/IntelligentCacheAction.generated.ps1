using namespace System.Management.Automation

class IntelligentCacheActionValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('AddUpdate', 'Delete')
	}
}
