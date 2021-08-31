class ConnectionPermission {
	[boolean]$IsEmpty
	[SecurityRoleOverride]$Override
	[SecurityRoleRight]$Right
	[string[]]$Roles

	ConnectionPermission() {
		$this.Override = [SecurityRoleOverride]::Default
		$this.Right = [SecurityRoleRight]::View
	}
}
