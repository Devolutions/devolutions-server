using module '..\enums\CustomInstallerStatus.generated.psm1'

class RDMOCustomInstaller
{
	[String]$CreationDate = $null
	[String]$CreationDateStr = ''
	[String]$Description = ''
	[String]$ErrorMessage = ''
	[String]$GenerationDate = $null
	[String]$GenerationDateStr = ''
	[String]$ID = ''
	[String]$Name = ''
	[CustomInstallerStatus]$Status = [CustomInstallerStatus]::new()
	[String]$TemplateName = ''
	[String]$UserID = ''
	[String]$UserName = ''
}
