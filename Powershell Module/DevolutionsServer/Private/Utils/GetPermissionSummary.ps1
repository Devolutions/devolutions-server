function GetPermissionSummary {
    Param (
        [Parameter(Mandatory)]
        [PSCustomObject]$entry,
        [string]$VaultName,
        [int]$Depth
    )
    $results = @()
    foreach ($sec in $entry.security) {

        #some special objects are returned, only handle RBAC permissions
        if ($sec.ViewRoles -is [system.array]) {

            $results += [PSCustomObject]@{
                Vault      = $vaultName
                Depth     = $Depth
                Entry      = $entry.Name
                IsOverride = [Devolutions.RemoteDesktopManager.SecurityRoleOverride]::Default
                Permission = [Devolutions.RemoteDesktopManager.SecurityRoleRight]::View
                Principal  = [string]::Join(', ', $sec.ViewRoles)
            }

        }

        foreach ($perm in $sec.Permissions) {

            #some special objects are returned, only handle RBAC permissions
            if ($perm.roles -is [system.array]) {

                $results += [PSCustomObject]@{
                    Vault      = $vaultName
                    Depth      = $Depth
                    Entry      = $entry.Name
                    IsOverride = [enum]::ToObject([Devolutions.RemoteDesktopManager.SecurityRoleOverride], $perm.override)
                    Permission = [enum]::ToObject([Devolutions.RemoteDesktopManager.SecurityRoleRight], $perm.right)
                    Principal  = [string]::Join(', ', $perm.roles)
                }
            }
        }
    }

    return $results
} 
