using namespace System.Management.Automation

class EventSubscriptionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Connection', 'DataSourceSettings', 'Group', 'Todo', 'User', 'Role', 'UserLockedOut', 'ConnectionOpened', 'Repository', 'EntryExpiring')
	}
}
