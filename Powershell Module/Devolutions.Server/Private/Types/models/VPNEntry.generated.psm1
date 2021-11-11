using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class VPNEntry : BaseSessionEntry 
{
	[String]$Domain = ''
	[String]$Host = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[String]$Username = ''
}
