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
                Roles    = @('User1', 'User2', 'Group1', 'Group2')
            },
            [ConnectionPermission]@{
                IsEmpty  = $false
                Override = [SecurityRoleOverride]::Inherited
                Right    = [SecurityRoleRight]::Edit
                Roles    = @('User1', 'User2', 'Group1', 'Group2')
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

        $Users = ($res = Get-DSUsers -All).isSuccess ? $res.Body.data : $(throw 'Could not fetch your users.')
        $UserGroups = ($res = Get-DSRole -GetAll).isSuccess ? $res.Body.data : $(throw 'Could not fetch your user groups.')

        if (!$EntrySecurity.permissions) {
            $EntrySecurity | Add-Member -NotePropertyName permissions -NotePropertyValue @()
        }

        $EntrySecurity | Add-Member -NotePropertyName roleOverride -NotePropertyValue $PermissionOverride -Force

        foreach ($Permission in $Permissions) {
            foreach ($Role in $Permission.Roles) {
                if ($null -ne ($User = $Users.GetEnumerator() | Where-Object { $_.name -eq $Role })) {
                    $Permission.Roles[$Permission.Roles.IndexOf($Role)] = "$Role|u"
                }
                elseif ($null -eq ($UserGroup = $UserGroups.GetEnumerator() | Where-Object { $_.name -eq $Role })) {
                    Write-Verbose "[Set-DSEntityPermissions] $Role was removed from $($Permission.Right) permission because it couldn't be located in your users or user groups."
                    $Permission.Roles = $Permission.Roles | Where-Object { $_ -ne $Role }
                }

            }

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

        $Entry.data = (Protect-ResourceToHexString (ConvertTo-Json $Entry.data))

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