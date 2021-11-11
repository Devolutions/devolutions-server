using module '..\enums\ARDSessionSelectRequestType.generated.psm1'
using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\enums\KeyboardHook.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'
using module '..\enums\VNCAuthentificationType.generated.psm1'
using module '..\enums\VNCCursorMode.generated.psm1'
using module '..\enums\VNCEncoding.generated.psm1'
using module '..\enums\VNCSelectDisplayMode.generated.psm1'

class AppleRemoteDesktopEntry : BaseSessionEntry 
{
	[ARDSessionSelectRequestType]$ARDSessionSelectRequestType = [ARDSessionSelectRequestType]::new()
	[VNCAuthentificationType]$AuthentificationType = [VNCAuthentificationType]::new()
	[int]$CustomCompressionLevel = 6
	[boolean]$DisableClipboard = $false
	[String]$Domain = ''
	[boolean]$EmulateThreeButton = $true
	[String]$Host = ''
	[KeyboardHook]$KeyboardHook = [KeyboardHook]::new()
	[VNCCursorMode]$MouseCursorMode = [VNCCursorMode]::new()
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[int]$Port = 5900
	[VNCEncoding]$PreferredEncoding = [VNCEncoding]::new()
	[boolean]$RequestSharedSession = $true
	[boolean]$Scaled = $true
	[int]$SelectDisplayIndex = 0
	[VNCSelectDisplayMode]$SelectDisplayMode = [VNCSelectDisplayMode]::new()
	[boolean]$SwapMouseButtons = $false
	[String]$Username = ''
	[boolean]$ViewOnly = $false
}
