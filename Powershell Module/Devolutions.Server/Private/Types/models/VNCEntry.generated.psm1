using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\enums\KeyboardHook.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'
using module '..\enums\VNCColorDepth.generated.psm1'
using module '..\enums\VNCCursorMode.generated.psm1'
using module '..\enums\VNCEmbeddedType.generated.psm1'
using module '..\enums\VNCEncoding.generated.psm1'
using module '..\enums\VNCType.generated.psm1'

class VNCEntry : BaseSessionEntry 
{
	[String]$ConfigFileName = ''
	[int]$CustomCompressionLevel = 6
	[boolean]$DisableClipboard = $false
	[String]$Domain = ''
	[String]$DSM = ''
	[String]$EmbeddedConfiguration = ''
	[int]$EmbeddedDelayx64Only = -1
	[boolean]$EmulateThreeButton = $true
	[boolean]$FullScreen = $false
	[boolean]$HideToolStrip = $false
	[String]$Host = ''
	[int]$JPEGCompressionLevel = 6
	[KeyboardHook]$KeyboardHook = [KeyboardHook]::new()
	[VNCCursorMode]$MouseCursorMode = [VNCCursorMode]::new()
	[String]$OtherParameters = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[int]$Port = 5900
	[VNCEncoding]$PreferredEncoding = [VNCEncoding]::new()
	[String]$ProxyHost = ''
	[boolean]$RequestSharedSession = $true
	[boolean]$Scaled = $true
	[VNCColorDepth]$ScreenColorDepth = [VNCColorDepth]::new()
	[boolean]$ShowStatus = $true
	[boolean]$SwapMouseButtons = $false
	[boolean]$TrackMouseMovement = $true
	[String]$Username = ''
	[boolean]$ViewOnly = $false
	[VNCEmbeddedType]$VncEmbeddedType = [VNCEmbeddedType]::new()
	[SensitiveItem]$VNCPasswordItem = [SensitiveItem]::new()
	[VNCType]$VNCType = [VNCType]::new()
}
