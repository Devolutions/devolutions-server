using namespace System.Management.Automation

class SecurityRoleRightValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('View', 'ViewPassword', 'Add', 'Delete', 'Edit', 'EditStatus', 'EditDescription', 'EditSecurity', 'PasswordHistory', 'ConnectionHistory', 'RemoteTools', 'Attachment', 'EditAttachment', 'Inventory', 'ViewLogs', 'Handbook', 'EditHandbook', 'WebManagementTools', 'ConsoleManagementTools', 'MacroScriptTools', 'MacroScriptToolsEntry', 'EditPassword', 'Execute', 'ViewSessionRecording', 'ViewInformation', 'Export', 'EditInformation')
	}
}
