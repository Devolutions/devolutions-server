using module '..\enums\CredentialSourceMode.generated.psm1'

class RepositoryShortcutEntry
{
	[String]$CredentialConnectionId = ''
	[CredentialSourceMode]$CredentialMode = [CredentialSourceMode]::new()
	[String]$FolderName = ''
	[String]$PersonalCredentialConnectionId = ''
	[String]$PrivateVaultSearchString = ''
	[String]$RepositoryID = ''
	[String]$RepositoryName = ''
}
