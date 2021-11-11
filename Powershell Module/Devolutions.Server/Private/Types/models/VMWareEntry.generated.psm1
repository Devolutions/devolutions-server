using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'
using module '..\enums\VMWareApplication.generated.psm1'

class VMWareEntry : BaseSessionEntry 
{
	[VMWareApplication]$Application = [VMWareApplication]::new()
	[String]$Username = ''
	[String]$Server = ''
	[String]$OtherParams = ''
	[boolean]$FullScreen = $false
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[String]$Filename = ''
	[boolean]$UseWindowsCredential = $false
}
