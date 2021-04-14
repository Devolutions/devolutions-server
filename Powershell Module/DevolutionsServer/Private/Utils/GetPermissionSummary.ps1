function GetPermissionSummary {
    Param (
        [Parameter(Mandatory)]
        [PSCustomObject]$entry,
        [string]$VaultName,
        [string]$indent
    )
    $results = @()
    foreach ($sec in $entry.security) {
        foreach ($view in $sec.ViewRoles) {
            $results +=  [PSCustomObject]@{
                Vault       = $vaultName
                Indent      = $indent
                Entry       = $entry.Name
                IsOverride  = 0
                Permission  = "View"
                Principal   = $view
            }
        }
        
        foreach ($perm in $sec.Permissions) {
            $results += [PSCustomObject]@{
                Vault       = $vaultName
                Indent      = $indent
                Entry       = $entry.Name
                IsOverride  = $perm.override
                Permission  = $perm.right
                Principal   = $view
            }
        }
    }
    return $results
} 
