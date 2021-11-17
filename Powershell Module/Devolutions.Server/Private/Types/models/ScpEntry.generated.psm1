using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\enums\PrivateKeyType.generated.psm1'
using module '..\enums\ProxyTunnelType.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'
using module '..\models\SSHGateway.generated.psm1'

class ScpEntry : BaseSessionEntry 
{
	[boolean]$AlwaysAskForPassword = $false
	[boolean]$CommandReplyLogEnabled = $false
	[String]$Directory = ''
	[boolean]$FtpSshAlwaysAskForPassword = $false
	[String]$FtpSshHost = ''
	[int]$FtpSshPort = 22
	[String]$FtpSshUserName = ''
	[String]$Host = ''
	[String]$LocalPath = ''
	[String]$LogPath = ''
	[boolean]$LogToFile = $false
	[boolean]$PassiveMode = $true
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[int]$Port = 22
	[String]$PrivateKeyConnectionID = ''
	[SensitiveItem]$PrivateKeyData = [SensitiveItem]::new()
	[String]$PrivateKeyFileName = ''
	[SensitiveItem]$PrivateKeyPassPhraseItem = [SensitiveItem]::new()
	[boolean]$PrivateKeyPromptForPassPhrase = $true
	[PrivateKeyType]$PrivateKeyType = [PrivateKeyType]::new()
	[String]$PrivateKeyPrivateVaultString = ''
	[boolean]$ProxyBypassOnLocal = $false
	[String]$ProxyDomain = ''
	[SensitiveItem]$ProxyPasswordItem = [SensitiveItem]::new()
	[int]$ProxyPort = 3128
	[ProxyTunnelType]$ProxyType = [ProxyTunnelType]::new()
	[String]$ProxyUrl = ''
	[String]$ProxyUserName = ''
	[boolean]$ShowFilesInTreeView = $false
	[boolean]$ShowHiddenFiles = $false
	[boolean]$ShowLocalFiles = $true
	[boolean]$SSL = $true
	[boolean]$TLS = $true
	[boolean]$UseFtpOverSsh = $false
	[boolean]$UseProxy = $false
	[String]$Username = ''
	[boolean]$UseSshAuthenticationAgent = $false
	[int]$VerboseLevel = 0
	[boolean]$UseSSHGateway = $false
	[SSHGateway]$SSHGateways = [SSHGateway]::new()
}