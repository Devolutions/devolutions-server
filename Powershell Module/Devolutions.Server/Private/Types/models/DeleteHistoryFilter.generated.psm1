using module '..\enums\DeleteHistoryMode.generated.psm1'
using module '..\enums\DeleteHistoryScope.generated.psm1'

class DeleteHistoryFilter
{
	[String]$ConnectionID = $null
	[int]$HistoryID = $null
	[String]$HistoryUuid = $null
	[DeleteHistoryMode]$Mode = [DeleteHistoryMode]::new()
	[String]$ModifiedDate = $null
	[String]$RepositoryID = $null
	[DeleteHistoryScope]$Scope = [DeleteHistoryScope]::new()
}
