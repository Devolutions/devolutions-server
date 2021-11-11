using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class HostEntry : BaseSessionEntry 
{
	[String]$Domain = ''
	[String]$Host = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[boolean]$PromptForHost = $false
	[String]$Username = ''
	[boolean]$UseTemplateCredentials = $false
	[boolean]$UseTemplateHost = $false
}
