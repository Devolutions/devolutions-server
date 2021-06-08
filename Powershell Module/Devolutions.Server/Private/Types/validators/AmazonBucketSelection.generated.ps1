using namespace System.Management.Automation

class AmazonBucketSelectionValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('ShowAll', 'ShowSpecific')
	}
}
