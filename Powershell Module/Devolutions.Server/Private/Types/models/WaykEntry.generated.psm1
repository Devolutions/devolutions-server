using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\enums\KeyboardHook.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'
using module '..\enums\WaykAuthType.generated.psm1'
using module '..\enums\WaykQualityMode.generated.psm1'

class WaykEntry : BaseSessionEntry 
{
	[String]$Host = ''
	[KeyboardHook]$KeyboardHook = [KeyboardHook]::new()
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[int]$Port = 4489
	[WaykAuthType]$PreferredAuthType = [WaykAuthType]::new()
	[WaykQualityMode]$QualityMode = [WaykQualityMode]::new()
	[boolean]$Scaled = $false
	[String]$Username = ''
}
