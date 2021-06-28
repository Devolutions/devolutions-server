using namespace System.Management.Automation

class TeamViewerConnectionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('RemoteControl', 'Presentation', 'FileTranfer', 'VPN', 'Choose')
	}
}
