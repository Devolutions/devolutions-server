class SecurityConnection : BaseConnection {
	[AllowOffline]$AllowOffline
	[CheckOutCommentMode]$CheckOutCommentMode
	[CheckOutMode]$CheckOutMode
	[CredentialInheritedMode]$ComplexityInheritedMode
	[boolean]$IsEmpty
	[int]$PasswordComplexityCustomMinimumLength
	[int]$PasswordComplexityCustomMinimumLowerCase
	[int]$PasswordComplexityCustomMinimumNumeric
	[int]$PasswordComplexityCustomMinimumSymbol
	[int]$PasswordComplexityCustomMinimumUpperCase
	[String]$PasswordComplexityId 
	[CredentialInheritedMode]$PasswordComplexityUsageInheritedMode
	[PasswordComplexityUsage]$PasswordComplexityUsageOverride
	[PasswordComplexityValidation]$PasswordComplexityValidationOverride
	[PasswordPwnedUsage]$PasswordPwnedUsage
	[ConnectionPermission]$Permissions
	[SecurityRoleOverride]$RoleOverride
	[int]$SelectedDayOfWeek
	[SynchronizeDocumentToOfflineMode]$SynchronizeDocumentToOfflineMode
	[TemporaryAccessAuthorizer]$TemporaryAccessAuthorizer
	[string[]]$TemporaryAccessAuthorizerIDs
	[TemporaryAccessMode]$TemporaryAccessMode
	[TimeBasedConnectionUsageDays]$TimeBasedUsageDays
	[String]$TimeBasedUsageEndTime
	[TimeBasedConnectionUsageHours]$TimeBasedUsageHours
	[String]$TimeBasedUsageStartTime
	[SecurityRoleOverride]$ViewOverride
	[string[]]$ViewRoles

	SecurityConnection() {
		$this.AllowOffline = [AllowOffline]::Default
		$this.CheckOutCommentMode = [CheckOutCommentMode]::Default
		$this.CheckOutMode = [CheckOutMode]::Default
		$this.ComplexityInheritedMode = [CredentialInheritedMode]::Default
		$this.PasswordComplexityUsageInheritedMode = [CredentialInheritedMode]::Default
		$this.PasswordComplexityUsageOverride = [PasswordComplexityUsage]::Default
		$this.PasswordComplexityValidationOverride = [PasswordComplexityValidation]::Default
		$this.PasswordPwnedUsage = [PasswordPwnedUsage]::Default
		$this.Permissions = [ConnectionPermission]::new()
		$this.RoleOverride = [SecurityRoleOverride]::Default
		$this.SynchronizeDocumentToOfflineMode = [SynchronizeDocumentToOfflineMode]::Default
		$this.TemporaryAccessAuthorizer = [TemporaryAccessAuthorizer]::Default
		$this.TemporaryAccessMode = [TemporaryAccessMode]::Default
		$this.TimeBasedUsageDays = [TimeBasedConnectionUsageDays]::Default
		$this.TimeBasedUsageHours = [TimeBasedConnectionUsageHours]::Default
		$this.ViewOverride = [SecurityRoleOverride]::Default
	}
}
