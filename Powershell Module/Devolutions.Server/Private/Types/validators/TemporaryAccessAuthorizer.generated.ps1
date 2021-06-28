using namespace System.Management.Automation

class TemporaryAccessAuthorizerValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Inherited', 'AdministratorOnly', 'Custom')
	}
}
