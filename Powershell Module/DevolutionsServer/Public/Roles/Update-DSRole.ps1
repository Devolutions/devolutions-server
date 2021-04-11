function Update-DSRole {
    <#
    .SYNOPSIS
    Updates a role if it exists.
    .DESCRIPTION
    Using the given parameters, it tries to update the role that matches the provided "candidRoleId". Backend use the same endpoint for creating/updating roles,
    but this module uses two different CMDlets. As such, if the role ID can't be matched, it returns an error. After that check, this cmdlet forges a updated "user" (role)
    object to send to the backend. The backend also verifies that the ID exists and that the user have the right to update a role.

    Possible parameters:
    candidRoleId        # Role ID to update
    displayName         # Role name (userSecurity.name) 
    description         # Role description (userAccount.fullName)
    isAdministrator
    allowDragAndDrop
    canAdd
    canEdit
    canDelete
    canImport
    canExport
    denyAddInRoot
    offlineMode
    .EXAMPLE
    $updatedRoleData = @{
        candidRoleId     = '2e5d7f28-f5b3-4008-a4f3-966833d5f1c5'
        description      = "Ceci est un update test"
        displayName      = "It worked"
        isAdministrator  = $false
        canAdd           = $true
        canEdit          = $true
        canDelete        = $true
        allowDragAndDrop = $true
        canImport        = $true
        canExport        = $true
        offlineMode      = $true
        denyAddInRoot    = $true
    }

    $res = Update-DSRole @updatedRoleData -Verbose
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$candidRoleId,
        [string]$displayName,
        [string]$description,
        [bool]$isAdministrator,
        [bool]$allowDragAndDrop,
        [bool]$canAdd,
        [bool]$canEdit,
        [bool]$canDelete,
        [bool]$canImport,
        [bool]$canExport,
        [bool]$denyAddInRoot,
        [int]$offlineMode
    )
    BEGIN {
        Write-Verbose '[Update-DSRole] Begin...'
        $URI = "$Script:DSBaseURI/api/security/role/save?csToXml=1"

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    PROCESS {
        try {
            $currentRole = foreach ($role in (Get-DSRoles).Body.data) {
                if ($role.id -eq $candidRoleId) {
                    $role
                    break
                }
            }

            if ($currentRole) {
                $possibleParam = @('candidRoleId', 'displayName', 'description', 'isAdministrator', 'allowDragAndDrop', 'canAdd', 'canEdit' , 'canDelete', 'canImport', 'canExport', 'denyAddInRoot', 'offlineMode')
                $updatedRoleData = @{
                    userAccount  = @{}
                    userSecurity = @{
                        customSecurityEntity = @{}
                    }
                }

                foreach ($param in $PSBoundParameters.GetEnumerator()) {
                    if ($possibleParam.Contains($param.Key)) {
                        switch ($param) {
                            { $param.Key -eq "candidRoleId" } { $updatedRoleData.userSecurity["ID"] = $param.Value }
                            { $param.Key -eq "description" } { $updatedRoleData.userAccount["fullName"] = $param.Value }
                            { $param.Key -in ('allowDragAndDrop', 'canImport', 'canExport', 'offlineMode', 'denyAddInRoot') } { $updatedRoleData.userSecurity.customSecurityEntity[$param.Key] = $param.Value }
                            Default { 
                                if ($param.Key -eq "displayName") { $updatedRoleData.userSecurity["name"] = $param.Value }
                                else { $updatedRoleData.userSecurity[$param.Key] = $param.Value }
                            }
                        }
                    }
                }

                $params = @{
                    Uri    = $URI
                    Method = 'PUT'
                    Body   = $updatedRoleData | ConvertTo-Json
                }
        
                return Invoke-DS @params 
            }
            else {
                throw "The supplied role ID couldn't be found. Make sure the ID of the role you are trying to update is valid."
            }
        }
        catch { 
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::Break -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
    }
    END {
        If ($?) {
            Write-Verbose '[Update-DSRole] Completed Successfully.'
        }
        else {
            Write-Verbose '[Update-DSRole] Ended with errors...'
        }
    }
}