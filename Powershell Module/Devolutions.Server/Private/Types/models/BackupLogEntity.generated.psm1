using module '..\enums\SaveMode.generated.psm1'

class BackupLogEntity
{
	[SaveMode]$SaveMode = [SaveMode]::new()
	[boolean]$Archived = $false
	[String]$BackupJobID = $null
	[String]$DatabaseFileName = ''
	[String]$EndDate = $null
	[String]$FileName = ''
	[String]$ID = $null
	[String]$Notes = ''
	[String]$StartDate = $null
	[boolean]$Success = $false
}
