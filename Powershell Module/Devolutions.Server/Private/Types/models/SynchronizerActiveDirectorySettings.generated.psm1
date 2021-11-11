using module '..\enums\ActiveDirectorySyncValueMapping.generated.psm1'

class SynchronizerActiveDirectorySettings
{
	[String]$DestinationFolder = ''
	[String]$TemplateId = ''
	[String]$TemplateName = ''
	[boolean]$CreateFolders = $false
	[int]$Level = 0
	[String]$FolderTemplateId = ''
	[String]$FolderTemplateName = ''
	[ActiveDirectorySyncValueMapping]$SessionName = [ActiveDirectorySyncValueMapping]::new()
	[String]$SessionNamePrefix = ''
	[String]$SessionNameSuffix = ''
	[ActiveDirectorySyncValueMapping]$Host = [ActiveDirectorySyncValueMapping]::new()
	[boolean]$ImportDescription = $false
	[String]$DescriptionAttributeOverride = ''
}
