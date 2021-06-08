using namespace System.Management.Automation

class InvalidIpFormatValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('AllowedSingle', 'AllowedMasked', 'DeniedSingle', 'DeniedMasked')
	}
}
