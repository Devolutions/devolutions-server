###########################################################################
#
# This highlights that DVLS was highly adapted for use by RDM.
# Until we can "flatten" the API to better meet with modern usage
# scenarios, hide the complexity by using this type of functions.
#
# we are aware of the risk of overflowing the stack space for deep 
# hierarchies, but we will address the issue if it pops up.
#
###########################################################################
function ListPermissionsRecursive {
    Param (
        [int]$Depth = 0,
        [PSCustomObject]$Folder,
        [string]$VaultName
    )
    if (!@(26, 92) -Contains $folder.ConnectionType) {
        throw "assertion - not a folder"
    }

    $results = @()
    # start by getting the folder's own permissions
    $innerRes = Get-DSEntry -EntryId $folder.id -IncludeAdvancedProperties
    $results += GetPermissionSummary -entry $innerRes.body.data -Depth $Depth -VaultName $VaultName
    $Depth++
    foreach ($entry in $folder.PartialConnections) {
        if ($entry.ConnectionType = 26) {
            $results += ListPermissionsRecursive -Depth $Depth -Folder $entry -VaultName $VaultName
        } else {
            $innerRes = Get-DSEntry -EntryId $entry.id -IncludeAdvancedProperties
            $results += GetPermissionSummary -entry $innerRes.body.data -Depth $Depth -VaultName $VaultName
        }
    }

    return $results
}
