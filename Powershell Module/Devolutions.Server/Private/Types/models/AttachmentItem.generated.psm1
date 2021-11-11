using module '..\enums\ConnectionDisplayMode.generated.psm1'
using module '..\models\DocumentConnection.generated.psm1'

class AttachmentItem
{
	[String]$ConnectionID = $null
	[String]$CreatedBy = ''
	[String]$CreationDate = $null
	[String]$CreationDateTime = $null
	[String]$Description = ''
	[ConnectionDisplayMode]$DisplayMode = [ConnectionDisplayMode]::new()
	[DocumentConnection]$Document = [DocumentConnection]::new()
	[String]$Filename = ''
	[String]$FormattedLocalCreationDate = ''
	[String]$FormattedSize = ''
	[String]$GroupName = ''
	[String]$HistoryID = ''
	[String]$ID = $null
	[boolean]$IsPrivate = $false
	[String]$LocalCreationDate = $null
	[String]$LocalModifiedDate = $null
	[String]$ModifiedDate = $null
	[String]$ModifiedLoggedUsername = ''
	[String]$ModifiedUsername = ''
	[String]$PrivateSubType = ''
	[String]$SafePassword = ''
	[String]$SecurityGroup = $null
	[int]$Size = 0
	[String]$Title = ''
}
