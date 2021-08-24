class DataSourcePermission {
	[boolean]$DataSourcePermissionDefaultValue
	[SecurityRoleOverride]$DataSourcePermissionValue
	[boolean]$IsEmpty
	[SecurityRoleOverride]$Override
	[SecurityRoleDataSourceRight]$Right
	[string[]]$Roles

	DataSourcePermission() {
		$this.DataSourcePermissionValue = [SecurityRoleOverride]::Default
		$this.Override = [SecurityRoleOverride]::Default
		$this.Right = [SecurityRoleDataSourceRight]::User
	}
}
