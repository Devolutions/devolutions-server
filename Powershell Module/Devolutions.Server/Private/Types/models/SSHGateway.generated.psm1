using module '..\enums\PrivateKeyType.generated.psm1'
using module '..\enums\ToolCredentialSource.generated.psm1'

class SSHGateway
{
	[String]$CredentialConnectionGroup = ''
	[String]$CredentialConnectionID = ''
	[String]$CredentialDynamicDescription = ''
	[String]$CredentialDynamicValue = ''
	[ToolCredentialSource]$CredentialSource = [ToolCredentialSource]::new()
	[String]$Host = ''
	[String]$ID = ''
	[String]$Password = ''
	[int]$Port = 0
	[String]$PortString = ''
	[String]$PrivateKeyConnectionID = ''
	[String]$PrivateKeyData = ''
	[String]$PrivateKeyFileName = ''
	[String]$PrivateKeyPassPhrase = ''
	[String]$PrivateKeyPrivateVaultString = ''
	[boolean]$PrivateKeyPromptForPassPhrase = $true
	[PrivateKeyType]$PrivateKeyType = [PrivateKeyType]::new()
	[String]$PrivateVaultString = ''
	[boolean]$PromptForCredentials = $false
	[String]$PublicKeyComment = ''
	[String]$PublicKeyValue = ''
	[String]$SafePassword = ''
	[String]$SafePrivateKeyData = ''
	[String]$SafePrivateKeyPassPhrase = ''
	[String]$Username = ''
}
