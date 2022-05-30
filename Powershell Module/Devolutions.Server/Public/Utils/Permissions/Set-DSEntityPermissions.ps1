function Set-DSEntityPermissions {
    <#
        .SYNOPSIS
        Sets the permissions on a given entity.
        .DESCRIPTION
        Sets the permissions on a given entity (Vault, folder or entry).
        .EXAMPLE
        $Permissions = @(
            [ConnectionPermission]@{
                IsEmpty  = $false
                Override = [SecurityRoleOverride]::Custom
                Right    = [SecurityRoleRight]::View
                Roles    = @($UserId1, $UserId2, $RoleId1)
            },
            [ConnectionPermission]@{
                IsEmpty  = $false
                Override = [SecurityRoleOverride]::Inherited
                Right    = [SecurityRoleRight]::Edit
                Roles    = @($UserId1, $UserId2, $RoleId1)
            }
        )

        > Set-DSEntityPermissions -EntityId $ID -Permissions $Permissions

        .NOTES
        - To override already existing permissions, please use the 'OverrideExistingPermissions' switch parameter.
        - When using this CMDlet, your entity's override mode will default to 'Custom'. Use the 'PermissionOverride' parameter if you wish to set it to anything else.
        .NOTES
        #>
    [CmdletBinding()]
    param (
        [guid]$EntityId = $(throw 'You must provide the ID of the entity for which you want to change the permissions.'),
        [SecurityRoleOverride]$PermissionOverride = [SecurityRoleOverride]::Custom,
        [ConnectionPermission[]]$Permissions,
        [switch]$OverrideExistingPermissions
    )
    
    begin {
        Write-Verbose '[Set-DSEntityPermissions] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $Entry = ($res = Get-DSEntry -EntryId $EntityId).isSuccess ? $res.Body.data : $(throw 'Could not find the requested entity.')
        $EntrySecurity = $Entry.security

        if (!$EntrySecurity.permissions) {
            $EntrySecurity | Add-Member -NotePropertyName permissions -NotePropertyValue @()
        }

        $EntrySecurity | Add-Member -NotePropertyName roleOverride -NotePropertyValue $PermissionOverride -Force

        foreach ($Permission in $Permissions) {
            $Right = $EntrySecurity.permissions.GetEnumerator() | Where-Object { $_.Right -eq $Permission.right }

            if ($Right -and !($Permission.Right -eq [SecurityRoleRight]::View)) {
                if (!$OverrideExistingPermissions) {
                    Write-Verbose "$($Permission.right) permission was ignored because it already exists on entity. If you wish to overrider existing permissions, use OverrideExisitingPermissions switch parameter. "
                }

                $Index = $EntrySecurity.permissions.Indexof($Right)
                $EntrySecurity.permissions[$Index] = $Permission
            }
            else {
                switch ($Permission.Right) {
                    ([SecurityRoleRight]::View) { 
                        $EntrySecurity | Add-Member -NotePropertyName viewOverride -NotePropertyValue $Permission.Override -Force
                        $EntrySecurity | Add-Member -NotePropertyName viewRoles -NotePropertyValue $Permission.Roles -Force
                    }
                    Default {
                        $EntrySecurity.permissions += $Permission
                    }
                }
            }
        }

        if ($Entry.connectionType -eq ([ConnectionType]::Group)) {
            $Entry.group = $Entry.group -match '\\' ? $Entry.group.Substring(0, $Entry.group.lastIndexOf('\')) : ''
        }

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/connections/partial/save"
            Method = 'PUT'
            Body   = (ConvertTo-Json $Entry -Depth 4)
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    end {
        $res.isSuccess ? (Write-Verbose '[Set-DSEntityPermissions] Completed successfully!') : (Write-Verbose '[Set-DSEntityPermissions] Ended with errors...')
    }
}