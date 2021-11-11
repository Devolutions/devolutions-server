using module '..\models\PasswordListItem.generated.psm1'
using module '..\enums\PasswordListSortPriority.generated.psm1'

class CredentialPasswordList
{
	[boolean]$AllowClipboard = $false
	[boolean]$AllowViewPasswordAction = $false
	[PasswordListSortPriority]$PasswordListSortPriority = [PasswordListSortPriority]::new()
	[PasswordListItem]$Passwords = [PasswordListItem]::new()
}
