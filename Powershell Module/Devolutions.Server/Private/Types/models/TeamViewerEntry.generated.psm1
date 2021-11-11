using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'
using module '..\enums\TeamViewerConnectionType.generated.psm1'

class TeamViewerEntry : BaseSessionEntry 
{
	[TeamViewerConnectionType]$ConnectionType = [TeamViewerConnectionType]::new()
	[String]$Id = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[boolean]$PromptForPassword = $false
	[int]$WaitTime = 5000
}
