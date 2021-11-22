function Set-DSEntityPermissions {
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