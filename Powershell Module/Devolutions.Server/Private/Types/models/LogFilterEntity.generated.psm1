using module '..\enums\ConnectionLogMessage.generated.psm1'
using module '..\enums\ConnectionLogMessageSubType.generated.psm1'
using module '..\enums\DateFilter.generated.psm1'

class LogFilterEntity
{
	[String]$ClosePrompt = ''
	[String]$Comment = ''
	[String]$ConnectionId = $null
	[String]$ConnectionName = ''
	[DateFilter]$DateFilter = [DateFilter]::new()
	[String]$EndDate = $null
	[String]$EndDateUTC = $null
	[String]$GroupName = ''
	[boolean]$IsClosePromptChecked = $false
	[boolean]$IsGroupChecked = $false
	[boolean]$IsMachineNameChecked = $false
	[boolean]$IsMessageChecked = $false
	[boolean]$IsPromptChecked = $false
	[boolean]$IsPrivate = $null
	[boolean]$IsUserNameChecked = $false
	[String]$LoggedUserName = ''
	[String]$LogID = $null
	[String]$MachineName = ''
	[String]$Message = ''
	[ConnectionLogMessage]$MessageType = [ConnectionLogMessage]::new()
	[ConnectionLogMessageSubType]$MessageSubType = [ConnectionLogMessageSubType]::new()
	[String]$Prompt = ''
	[String]$RepositoryID = $null
	[String]$StartDate = $null
	[String]$StartDateUTC = $null
	[String]$TicketNumber = ''
	[int]$TopX = 0
	[String]$UserID = $null
	[String]$UserName = ''
	[String]$RepositoriesID = $null
	[String]$DevolutionsGatewaySessionId = $null
}
