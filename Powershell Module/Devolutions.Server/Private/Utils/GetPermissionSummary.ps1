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
                Vault        = $vaultName
                Depth        = $Depth
                Entry        = $entry.Name
                OverrideType = [SecurityRoleOverride]::Default
                Right        = [SecurityRoleRight]::View
                Principals   = [string]::Join(', ', $sec.ViewRoles)
            }

        }

        foreach ($perm in $sec.Permissions) {

            #some special objects are returned, only handle RBAC permissions
            if ($perm.roles -is [system.array]) {

                $results += [PSCustomObject]@{
                    Vault        = $vaultName
                    Depth        = $Depth
                    Entry        = $entry.Name
                    OverrideType = [enum]::ToObject([SecurityRoleOverride], $perm.override)
                    Right        = [enum]::ToObject([SecurityRoleRight], $perm.right)
                    Principals   = [string]::Join(', ', $perm.roles)
                }
            }
        }
    }

    return $results
} 
