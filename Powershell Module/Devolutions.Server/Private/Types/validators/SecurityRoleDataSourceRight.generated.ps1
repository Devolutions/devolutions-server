using namespace System.Management.Automation

class SecurityRoleDataSourceRightValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('User', 'Role', 'Repository', 'SecurityGroup', 'DataSourceSettings', 'Export', 'Import', 'AddInRoot', 'Root', 'Report', 'ViewDeleted', 'ViewServerLogs', 'ViewLogs', 'Template', 'DefaultEntryTemplate', 'PasswordTemplate', 'ViewAdministrationLogs', 'RemoteTools', 'WebManagementTools', 'ConsoleManagementTools', 'MacroScriptTools', 'MacroScriptToolsEntry', 'AllowCheckinOverride', 'RepositoryAdd', 'PamAccess', 'PamAllowCheckoutWithoutRequest', 'PamManageCredentials', 'PamManageRequest', 'ViewRecordings', 'ViewInformation', 'License', 'FlagAsClosed', 'PamExport', 'GatewaysManage')
	}
}
