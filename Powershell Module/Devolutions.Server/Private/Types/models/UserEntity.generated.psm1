using module '..\models\UserAccountEntity.generated.psm1'
using module '..\models\UserProfileEntity.generated.psm1'
using module '..\models\UserSecurityEntity.generated.psm1'

class UserEntity
{
	[string[]]$AllGroups = [string[]]::new()
	[String]$AllRepositoryIds = $null
	[String]$CreationDate = $null
	[boolean]$DisableUserGravatar = $false
	[String]$Display = ''
	[string[]]$Groups = [string[]]::new()
	[String]$ID = $null
	[String]$Key = $null
	[string[]]$RoleGroups = [string[]]::new()
	[string[]]$Roles = [string[]]::new()
	[boolean]$SendEmailInvite = $false
	[UserAccountEntity]$UserAccount = [UserAccountEntity]::new()
	[UserProfileEntity]$UserProfile = [UserProfileEntity]::new()
	[UserSecurityEntity]$UserSecurity = [UserSecurityEntity]::new()
}
