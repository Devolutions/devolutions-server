using module '..\models\BaseSessionEntry.generated.psm1'

class TftpEntry : BaseSessionEntry 
{
	[String]$Host = ''
	[String]$LocalPath = ''
	[String]$LogPath = ''
	[boolean]$LogToFile = $false
	[int]$Port = 69
	[boolean]$ShowLocalFiles = $true
	[boolean]$ShowLogs = $false
	[boolean]$Verbose = $false
}
