function Get-DSFoldersRecurivse {
    param (
        $Folder
    ) 

    if ($Folder.partialConnections.Length -gt 0) {
        $Folder.partialConnections | ForEach-Object {
            if ($_.connectionType -eq [ConnectionType]::Group) {
                if ($_.partialConnections.Length -gt 0) {
                    Get-DSFoldersRecurivse $_
                }
                
                $_
            }
        }
    }
}