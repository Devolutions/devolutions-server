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
        [string]$Indent,
        [PSCustomObject]$Folder,
        [string]$VaultName
    )
    if (!@(26, 92) -Contains $folder.ConnectionType) {
        throw "assertion - not a folder"
    }
    if ($null -eq $Indent) {
        $Indent = ''
    } 

    $results = @()
    # start by getting the folder's own permissions
    $innerRes = Get-DSEntry -EntryId $folder.id -IncludeAdvancedProperties
    $results += GetPermissionSummary -entry $innerRes.body.data -Indent $Indent -VaultName $VaultName
    $Indent += '  '
    foreach ($entry in $folder.PartialConnections) {
        if ($entry.ConnectionType = 26) {
            $results += ListPermissionsRecursive -indent $indent -Folder $entry -VaultName $VaultName
        }
        $innerRes = Get-DSEntry -EntryId $entry.id -IncludeAdvancedProperties
        $results += GetPermissionSummary -entry $innerRes.body.data -Indent $Indent -VaultName $VaultName
    }

    return $results
}
