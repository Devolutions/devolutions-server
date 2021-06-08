using namespace System.Management.Automation

class RDMOApplyLicenseResultValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('InvalidLicense', 'Success', 'AlreadyUsed', 'Expired', 'Error', 'TrialNotValid', 'MaximumReached')
	}
}
