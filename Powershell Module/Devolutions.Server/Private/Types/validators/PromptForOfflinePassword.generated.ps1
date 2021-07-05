using namespace System.Management.Automation

class PromptForOfflinePasswordValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Never', 'AlwaysPrompt', 'PromptIfAskForPassword', 'PromptOnOpenOffline', 'PromptOnOpenOfflineIfAskForPassword')
	}
}
