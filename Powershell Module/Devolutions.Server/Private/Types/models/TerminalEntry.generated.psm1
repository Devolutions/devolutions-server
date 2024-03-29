using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\enums\DefaultBoolean.generated.psm1'
using module '..\enums\InternetProtocol.generated.psm1'
using module '..\models\PortForward.generated.psm1'
using module '..\enums\PrivateKeyType.generated.psm1'
using module '..\enums\ProxyMode.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'
using module '..\models\SSHGateway.generated.psm1'
using module '..\enums\TelnetTerminalDnsLookupType.generated.psm1'
using module '..\enums\TelnetTerminalProxyType.generated.psm1'
using module '..\enums\TerminalAutoWrap.generated.psm1'
using module '..\enums\TerminalBackspaceKeyMode.generated.psm1'
using module '..\enums\TerminalBellMode.generated.psm1'
using module '..\enums\TerminalCursorBlink.generated.psm1'
using module '..\enums\TerminalCursorKeyMode.generated.psm1'
using module '..\enums\TerminalCursorType.generated.psm1'
using module '..\enums\TerminalDisconnectAction.generated.psm1'
using module '..\enums\TerminalEncoding.generated.psm1'
using module '..\enums\TerminalFontMode.generated.psm1'
using module '..\enums\TerminalFunctionKeysMode.generated.psm1'
using module '..\enums\TerminalHomeEndKeyMode.generated.psm1'
using module '..\enums\TerminalKeypadMode.generated.psm1'
using module '..\enums\TerminalLocalEcho.generated.psm1'
using module '..\enums\TerminalLogMode.generated.psm1'
using module '..\enums\TerminalLogOverwriteMode.generated.psm1'
using module '..\enums\TerminalMouseClickMode.generated.psm1'
using module '..\enums\ToolCredentialSource.generated.psm1'
using module '..\enums\X11AuthenticationProtocol.generated.psm1'

class TerminalEntry : BaseSessionEntry 
{
	[DefaultBoolean]$ResetScrollOnDisplay = [DefaultBoolean]::new()
	[string[]]$BeforeDisconnectMacrosMore = [string[]]::new()
	[int]$AfterConnectMacroDelay = 500
	[boolean]$AfterConnectMacroEnterAfterCommand = $true
	[string[]]$AfterConnectMacros = [string[]]::new()
	[boolean]$AllowAgentForwarding = $false
	[DefaultBoolean]$AlwaysAcceptFingerprintDefaultBoolean = [DefaultBoolean]::new()
	[boolean]$AlwaysAskForPassword = $false
	[boolean]$AlwaysAskForSshPassword = $false
	[TerminalAutoWrap]$AutoWrap = [TerminalAutoWrap]::new()
	[TerminalBackspaceKeyMode]$BackspaceKeyMode = [TerminalBackspaceKeyMode]::new()
	[int]$BeforeDisconnectMacroDelay = 500
	[boolean]$BeforeDisconnectMacroEnterAfterCommand = $true
	[string[]]$BeforeDisconnectMacros = [string[]]::new()
	[TerminalBellMode]$BellMode = [TerminalBellMode]::new()
	[boolean]$CloseOnDisconnect = $false
	[TerminalCursorBlink]$CursorBlink = [TerminalCursorBlink]::new()
	[TerminalCursorKeyMode]$CursorKeyMode = [TerminalCursorKeyMode]::new()
	[TerminalCursorType]$CursorType = [TerminalCursorType]::new()
	[DefaultBoolean]$DisableKeypadMode = [DefaultBoolean]::new()
	[TerminalDisconnectAction]$DisconnectAction = [TerminalDisconnectAction]::new()
	[String]$Domain = ''
	[String]$DoubleClickDelimiters = ''
	[boolean]$EnableLogging = $false
	[boolean]$EnableTCPKeepalives = $false
	[TerminalEncoding]$Encoding = [TerminalEncoding]::new()
	[TerminalFontMode]$FontMode = [TerminalFontMode]::new()
	[boolean]$ForceNonDestructiveBackspace = $false
	[TerminalFunctionKeysMode]$FunctionKeysMode = [TerminalFunctionKeysMode]::new()
	[boolean]$GssApiAuthentication = $false
	[boolean]$HideOnConnect = $false
	[TerminalHomeEndKeyMode]$HomeEndKeyMode = [TerminalHomeEndKeyMode]::new()
	[String]$Host = ''
	[int]$HostPort = 22
	[boolean]$ImplicitCRinLF = $false
	[boolean]$ImplicitLFinCR = $false
	[InternetProtocol]$InternetProtocol = [InternetProtocol]::new()
	[TerminalKeypadMode]$KeypadMode = [TerminalKeypadMode]::new()
	[String]$LinkedProxyID = ''
	[TerminalLocalEcho]$LocalEcho = [TerminalLocalEcho]::new()
	[TerminalLogMode]$LogMode = [TerminalLogMode]::new()
	[TerminalLogOverwriteMode]$LogOverwriteMode = [TerminalLogOverwriteMode]::new()
	[String]$LogPath = ''
	[int]$MaxScrollbackLines = 2000
	[TerminalMouseClickMode]$MouseClickMode = [TerminalMouseClickMode]::new()
	[boolean]$NoShell = $false
	[String]$OverrideTerminalName = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[PortForward]$PortForwards = [PortForward]::new()
	[String]$PrivateKeyConnectionID = ''
	[SensitiveItem]$PrivateKeyData = [SensitiveItem]::new()
	[String]$PrivateKeyFileName = ''
	[SensitiveItem]$PrivateKeyPassPhraseItem = [SensitiveItem]::new()
	[boolean]$PrivateKeyPromptForPassPhrase = $false
	[String]$PrivateKeyPrivateVaultString = ''
	[PrivateKeyType]$PrivateKeyType = [PrivateKeyType]::new()
	[TelnetTerminalDnsLookupType]$ProxyDnsLookupType = [TelnetTerminalDnsLookupType]::new()
	[String]$ProxyExcludedHosts = ''
	[String]$ProxyHost = ''
	[int]$ProxyHostPort = 0
	[boolean]$ProxyLocalHostConnections = $false
	[ProxyMode]$ProxyMode = [ProxyMode]::new()
	[SensitiveItem]$ProxyPasswordItem = [SensitiveItem]::new()
	[String]$ProxyTelnetCommand = ''
	[TelnetTerminalProxyType]$ProxyType = [TelnetTerminalProxyType]::new()
	[String]$ProxyUserName = ''
	[int]$ReconnectDelay = 30
	[String]$RemoteCommand = ''
	[boolean]$ShowLogs = $false
	[boolean]$SilentMode = $false
	[String]$SSHGatewayCredentialConnectionID = ''
	[ToolCredentialSource]$SSHGatewayCredentialSource = [ToolCredentialSource]::new()
	[String]$SSHGatewayCredentialDynamicValue = ''
	[String]$SSHGatewayCredentialDynamicDescription = ''
	[String]$SSHGatewayHost = ''
	[SensitiveItem]$SSHGatewayPasswordItem = [SensitiveItem]::new()
	[int]$SSHGatewayPort = 22
	[String]$SSHGatewayPrivateKeyConnectionID = ''
	[SensitiveItem]$SSHGatewayPrivateKeyData = [SensitiveItem]::new()
	[String]$SSHGatewayPrivateKeyFileName = ''
	[SensitiveItem]$SSHGatewayPrivateKeyPassPhraseItem = [SensitiveItem]::new()
	[boolean]$SSHGatewayPrivateKeyPromptForPassPhrase = $true
	[PrivateKeyType]$SSHGatewayPrivateKeyType = [PrivateKeyType]::new()
	[String]$SSHGatewayUsername = ''
	[int]$TCPKeepaliveInterval = 0
	[boolean]$TryAgent = $false
	[String]$Username = ''
	[boolean]$UseSSHGateway = $false
	[SSHGateway]$SSHGateways = [SSHGateway]::new()
	[DefaultBoolean]$EnableX11Forwarding = [DefaultBoolean]::new()
	[int]$VerboseLevel = 0
	[String]$X11AuthorityFilePath = ''
	[String]$X11DisplayLocation = ''
	[X11AuthenticationProtocol]$X11Protocol = [X11AuthenticationProtocol]::new()
	[string[]]$AfterConnectMacrosMore = [string[]]::new()
}
