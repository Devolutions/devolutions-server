using namespace System.Management.Automation

class ProtocolHandlerActionValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Unknown', 'Open', 'Edit', 'View', 'Find', 'OpenWithMacro', 'ExportReport', 'Select', 'ApprovePAM', 'CheckInPAM', 'SaveAs', 'SelectVault', 'Report', 'ListAccessRequests', 'ApproveAccessRequest', 'DenyAccessRequest', 'RefreshRootDashboard', 'TopicusLogin', 'ShowLicenses', 'RegisterProduct', 'HideWarning', 'CloseWarning', 'OpenUrl', 'SortSecurityDashboardRecommendations', 'ViewUpcomingTodos', 'ViewOverdueTodos', 'ViewTodo')
	}
}
