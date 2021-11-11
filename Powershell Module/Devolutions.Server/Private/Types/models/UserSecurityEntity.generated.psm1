using module '..\models\BaseExternalUserId.generated.psm1'
using module '..\models\CustomSecurity.generated.psm1'
using module '..\enums\DefaultBoolean.generated.psm1'
using module '..\models\HasAccessDefaultOverride.generated.psm1'
using module '..\models\Repository.generated.psm1'
using module '..\enums\UserLicenceTypeMode.generated.psm1'

class UserSecurityEntity
{
	[CustomSecurity]$CustomSecurityEntity = [CustomSecurity]::new()
	[DefaultBoolean]$DeleteSQLLogin = [DefaultBoolean]::new()
	[HasAccessDefaultOverride]$HasAccessDefaultOverride = [HasAccessDefaultOverride]::new()
	[boolean]$IsServerUserTypeAssumed = $false
	[Repository]$RepositoryEntities = [Repository]::new()
	[BaseExternalUserId]$ExternalUserId = [BaseExternalUserId]::new()
	[String]$RepositoryNames = ''
	[String]$DomainName = ''
	[String]$ServerUserTypeString = ''
	[UserLicenceTypeMode]$UserLicenceType = [UserLicenceTypeMode]::new()
	[String]$UserTypeString = ''
	[int]$AuthenticationType = $null
	[boolean]$CanAdd = $false
	[boolean]$CanDelete = $false
	[boolean]$CanEdit = $false
	[String]$CreatedByLoggedUserName = ''
	[String]$CreatedByUserName = ''
	[String]$CreationDate = $null
	[String]$CustomSecurity = ''
	[String]$Assigned = ''
	[boolean]$HasAccessAndroidRDM = $true
	[boolean]$HasAccessCli = $true
	[boolean]$HasAccessIOSRDM = $true
	[boolean]$HasAccessLauncher = $true
	[boolean]$HasAccessLinuxRDM = $true
	[boolean]$HasAccessMacRDM = $true
	[boolean]$HasAccessRDM = $true
	[boolean]$HasAccessScripting = $true
	[boolean]$HasAccessWeb = $true
	[boolean]$HasAccessWebLogin = $true
	[boolean]$HasAccessWindowsRDM = $true
	[boolean]$HasAccessWorkspace = $true
	[String]$ID = $null
	[boolean]$IsAdministrator = $false
	[boolean]$IsEnabled = $true
	[boolean]$IsLockedOut = $false
	[String]$LastLockoutDate = $null
	[String]$LoginEmail = ''
	[String]$ModifiedDate = $null
	[String]$ModifiedLoggedUserName = ''
	[String]$ModifiedUserName = ''
	[String]$Name = ''
	[String]$Repositories = ''
	[String]$SecurityKey = ''
	[String]$UPN = ''
	[int]$UserType = 0
}
