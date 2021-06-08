using namespace System.Management.Automation

class RDPRedirectedDrivesValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('AllDrives', 'SpecificDrives')
	}
}
