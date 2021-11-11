using module '..\enums\CredentialSourceMode.generated.psm1'
using module '..\enums\EmailAuthenticationType.generated.psm1'
using module '..\models\PartialConnectionCredentials.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class DataEntryEmailAccount
{
	[String]$CredentialConnectionId = ''
	[CredentialSourceMode]$CredentialMode = [CredentialSourceMode]::new()
	[PartialConnectionCredentials]$Credentials = [PartialConnectionCredentials]::new()
	[String]$Email = ''
	[EmailAuthenticationType]$IMAPAuthentication = [EmailAuthenticationType]::new()
	[String]$IMAPHostName = ''
	[SensitiveItem]$IMAPPasswordItem = [SensitiveItem]::new()
	[int]$IMAPPort = 143
	[boolean]$IMAPSSL = $false
	[String]$IMAPUserName = ''
	[EmailAuthenticationType]$POPAuthentication = [EmailAuthenticationType]::new()
	[String]$POPHostName = ''
	[SensitiveItem]$POPPasswordItem = [SensitiveItem]::new()
	[int]$POPPort = 110
	[boolean]$POPSSL = $false
	[String]$POPUserName = ''
	[boolean]$SMIME = $false
	[EmailAuthenticationType]$SMTPAuthentication = [EmailAuthenticationType]::new()
	[String]$SMTPHostName = ''
	[SensitiveItem]$SMTPPasswordItem = [SensitiveItem]::new()
	[int]$SMTPPort = 25
	[boolean]$SMTPRequiresAuthentication = $false
	[boolean]$SMTPSSL = $false
	[String]$SMTPUserName = ''
	[boolean]$SMTPUseSamesAsIncoming = $false
	[String]$Url = ''
	[String]$YourName = ''
}
