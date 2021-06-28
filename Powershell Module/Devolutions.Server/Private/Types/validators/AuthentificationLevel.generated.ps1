using namespace System.Management.Automation

class AuthentificationLevelValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('ConnectDontWarnMe', 'DontConnect', 'WarnMe', 'Default')
	}
}
