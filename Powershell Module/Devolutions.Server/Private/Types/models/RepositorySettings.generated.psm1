using module '..\models\QuickAddEntry.generated.psm1'

class RepositorySettings
{
	[boolean]$AlwaysAskForOldPassword = $false
	[String]$MasterPasswordHash = ''
	[QuickAddEntry]$QuickAddEntries = [QuickAddEntry]::new()
}
