using namespace System.Management.Automation

class AlternateTwoFactorTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('None', 'Email', 'BackupCodes')
	}
}
