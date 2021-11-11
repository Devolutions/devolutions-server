using module '..\enums\AllowOffline.generated.psm1'
using module '..\models\BaseConnection.generated.psm1'
using module '..\enums\CheckOutCommentMode.generated.psm1'
using module '..\enums\CheckOutMode.generated.psm1'
using module '..\models\ConnectionPermission.generated.psm1'
using module '..\enums\CredentialInheritedMode.generated.psm1'
using module '..\enums\PasswordComplexityUsage.generated.psm1'
using module '..\enums\PasswordComplexityValidation.generated.psm1'
using module '..\enums\PasswordPwnedUsage.generated.psm1'
using module '..\enums\SecurityRoleOverride.generated.psm1'
using module '..\enums\SynchronizeDocumentToOfflineMode.generated.psm1'
using module '..\enums\TemporaryAccessAuthorizer.generated.psm1'
using module '..\enums\TemporaryAccessMode.generated.psm1'
using module '..\enums\TimeBasedConnectionUsageDays.generated.psm1'
using module '..\enums\TimeBasedConnectionUsageHours.generated.psm1'

class SecurityConnection : BaseConnection 
{
	[AllowOffline]$AllowOffline = [AllowOffline]::new()
	[CheckOutCommentMode]$CheckOutCommentMode = [CheckOutCommentMode]::new()
	[CheckOutMode]$CheckOutMode = [CheckOutMode]::new()
	[CredentialInheritedMode]$ComplexityInheritedMode = [CredentialInheritedMode]::new()
	[boolean]$IsEmpty = $false
	[int]$PasswordComplexityCustomMinimumLength = 0
	[int]$PasswordComplexityCustomMinimumLowerCase = 0
	[int]$PasswordComplexityCustomMinimumNumeric = 0
	[int]$PasswordComplexityCustomMinimumSymbol = 0
	[int]$PasswordComplexityCustomMinimumUpperCase = 0
	[String]$PasswordComplexityId = ''
	[CredentialInheritedMode]$PasswordComplexityUsageInheritedMode = [CredentialInheritedMode]::new()
	[PasswordComplexityUsage]$PasswordComplexityUsageOverride = [PasswordComplexityUsage]::new()
	[PasswordComplexityValidation]$PasswordComplexityValidationOverride = [PasswordComplexityValidation]::new()
	[PasswordPwnedUsage]$PasswordPwnedUsage = [PasswordPwnedUsage]::new()
	[ConnectionPermission]$Permissions = [ConnectionPermission]::new()
	[SecurityRoleOverride]$RoleOverride = [SecurityRoleOverride]::new()
	[int]$SelectedDayOfWeek = 0
	[SynchronizeDocumentToOfflineMode]$SynchronizeDocumentToOfflineMode = [SynchronizeDocumentToOfflineMode]::new()
	[TemporaryAccessAuthorizer]$TemporaryAccessAuthorizer = [TemporaryAccessAuthorizer]::new()
	[string[]]$TemporaryAccessAuthorizerIDs = @()
	[TemporaryAccessMode]$TemporaryAccessMode = [TemporaryAccessMode]::new()
	[TimeBasedConnectionUsageDays]$TimeBasedUsageDays = [TimeBasedConnectionUsageDays]::new()
	[String]$TimeBasedUsageEndTime = ''
	[TimeBasedConnectionUsageHours]$TimeBasedUsageHours = [TimeBasedConnectionUsageHours]::new()
	[String]$TimeBasedUsageStartTime = ''
	[SecurityRoleOverride]$ViewOverride = [SecurityRoleOverride]::new()
	[string[]]$ViewRoles = @()
}
