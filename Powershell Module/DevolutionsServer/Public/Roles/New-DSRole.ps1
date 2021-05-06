function New-DSRole {
    <#
    .SYNOPSIS
    Creates a new role.
    .DESCRIPTION
    Creates a new role and pre-validate offlineMode value, if supplied.
    .EXAMPLE
    $newRoleData = @{
        displayName = "Test"
        description = "This is a test role"
        canAdd = $true
        canDelete = $false
        offlineMode = 3
        allowDragAndDrop = $false
    }

    $res = New-DSRole @newRoleData -Verbose
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
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
        Write-Verbose '[New-DSRole] Beginning...'
        $URI = "$Global:DSBaseURI/api/security/role/save?csToXml=1"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session invalid. Please call New-DSSession."
        }

        if ($offlineMode) {
            if ($offlineMode -notin @('0', '2', '3')) {
                throw "Offline mode invalid. Should be 0 (Disabled), 2 (Read-only) or 3 (Read-write)."
            }
        }
    }

    PROCESS {
        $newRoleData = @{
            userAccount  = @{
                fullName = $description
            }
            userSecurity = @{
                name                 = $displayName
                isAdministrator      = $isAdministrator
                canAdd               = $canAdd
                canEdit              = $canEdit
                canDelete            = $canDelete
                repositoryEntities   = @() #TODO maybe? Would require fetching all vaults and looking through them to see if it exists
                customSecurityEntity = @{
                    allowDragAndDrop = $allowDragAndDrop
                    canImport        = $canImport
                    canExport        = $canExport
                    offlineMode      = $offlineMode
                    denyAddInRoot    = $denyAddInRoot
                }
            }
        }

        $params = @{
            Uri    = $URI
            Method = 'PUT'
            Body   = $newRoleData | ConvertTo-Json
        }

        $res = Invoke-DS @params
        return $res
    }

    END {
        If ($res.isSuccess) {
            Write-Verbose '[New-DSRole] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSRole] Ended with errors...'
        }
    }    
}