using module '..\enums\ConnectionLogMessage.generated.psm1'

class LogEntryEntity
{
	[int]$ActiveTime = $null
	[int]$ActivityDuration = $null
	[String]$Application = ''
	[int]$CloseMode = $null
	[String]$ClosePrompt = ''
	[String]$Comment = ''
	[String]$ConnectionID = $null
	[String]$ConnectionName = ''
	[String]$ConnectionTypeName = ''
	[String]$ConnectionUserName = ''
	[int]$Cost = $null
	[String]$CreationDate = $null
	[String]$Data = ''
	[String]$Details = ''
	[String]$DetailsID = $null
	[String]$EndDateTime = $null
	[String]$EndDateTimeUTC = $null
	[String]$GroupName = ''
	[String]$HostName = ''
	[String]$ID = $null
	[boolean]$IsEmbedded = $null
	[boolean]$IsPrivate = $false
	[String]$LoggedUserName = ''
	[String]$MachineName = ''
	[String]$Message = ''
	[ConnectionLogMessage]$MessageType = [ConnectionLogMessage]::new()
	[String]$MessageTypeTranslated = ''
	[int]$OpenMode = $null
	[String]$PamCredentialID = $null
	[String]$PrivateUserID = $null
	[String]$Prompt = ''
	[String]$RepositoryID = $null
	[String]$RepositoryName = ''
	[String]$SecurityGroup = ''
	[String]$StartDateTime = $null
	[String]$StartDateTimeUTC = $null
	[String]$Status = ''
	[boolean]$SupportClose = $null
	[String]$TicketNumber = ''
	[String]$UserName = ''
	[String]$Version = ''
}
