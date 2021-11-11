using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\enums\PrivateKeyType.generated.psm1'
using module '..\enums\ProxyTunnelType.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class WebDavEntry : BaseSessionEntry 
{
	[boolean]$AlwaysAskForPassword = $false
	[boolean]$CommandReplyLogEnabled = $false
	[String]$Directory = ''
	[String]$Domain = ''
	[String]$HomeDirectory = ''
	[String]$Host = ''
	[String]$LocalPath = ''
	[String]$LogPath = ''
	[boolean]$LogToFile = $false
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[int]$Port = 80
	[String]$PrivateKeyConnectionID = ''
	[SensitiveItem]$PrivateKeyData = [SensitiveItem]::new()
	[String]$PrivateKeyFileName = ''
	[boolean]$PrivateKeyPromptForPassPhrase = $true
	[SensitiveItem]$PrivateKeyPassPhraseItem = [SensitiveItem]::new()
	[PrivateKeyType]$PrivateKeyType = [PrivateKeyType]::new()
	[boolean]$ProxyBypassOnLocal = $false
	[String]$ProxyDomain = ''
	[String]$ProxyHost = ''
	[SensitiveItem]$ProxyPasswordItem = [SensitiveItem]::new()
	[int]$ProxyPort = 0
	[ProxyTunnelType]$ProxyType = [ProxyTunnelType]::new()
	[String]$ProxyUserName = ''
	[boolean]$ShowFilesInTreeView = $false
	[boolean]$ShowLocalFiles = $false
	[boolean]$SshAlwaysAskForPassword = $false
	[String]$SshHost = ''
	[SensitiveItem]$SshPasswordItem = [SensitiveItem]::new()
	[int]$SshPort = 0
	[String]$SshUserName = ''
	[boolean]$UseProxy = $false
	[String]$Username = ''
	[boolean]$UseSshAuthenticationAgent = $false
	[boolean]$UseSsl = $false
	[boolean]$UseWebDavOverSsh = $false
	[int]$VerboseLevel = 0
}
