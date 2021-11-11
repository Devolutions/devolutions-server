using module '..\models\RepositorySettings.generated.psm1'

class RepositoryEntity
{
	[boolean]$HasCustomImage = $false
	[String]$IDString = ''
	[boolean]$IsPrivate = $false
	[RepositorySettings]$RepositorySettings = [RepositorySettings]::new()
	[String]$RepositorySettingsValue = ''
	[boolean]$Selected = $false
	[String]$CreationDate = $null
	[String]$Description = ''
	[String]$ID = $null
	[String]$ImageBytes = ''
	[String]$ImageName = ''
	[boolean]$IsAllowedOffline = $true
	[String]$ModifiedDate = $null
	[String]$ModifiedLoggedUserName = ''
	[String]$ModifiedUserName = ''
	[String]$Name = ''
}
