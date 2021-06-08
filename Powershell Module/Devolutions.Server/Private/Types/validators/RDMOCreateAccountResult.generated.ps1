using namespace System.Management.Automation

class RDMOCreateAccountResultValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Error', 'Success', 'UserAlreadyExists', 'InvalidParameters')
	}
}
