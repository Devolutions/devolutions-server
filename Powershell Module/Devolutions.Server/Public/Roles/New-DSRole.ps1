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
        [ValidateSet([ServerUserType]::Builtin, [ServerUserType]::Domain, [ServerUserType]::AzureAD)]
        [string]$AuthenticationType = [ServerUserType]::Builtin,
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
        [int]$offlineMode,
        [string]$domainName = $null
    )

    BEGIN {
        Write-Verbose '[New-DSRole] Beginning...'
        $URI = "$Script:DSBaseURI/api/security/role/save"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }

        if ($offlineMode) {
            if ($offlineMode -notin @('0', '2', '3')) {
                throw 'Offline mode invalid. Should be 0 (Disabled), 2 (Read-only) or 3 (Read-write).'
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
                authenticationType   = 0
                canAdd               = $canAdd
                canEdit              = $canEdit
                canDelete            = $canDelete
                repositoryEntities   = @() #TODO maybe? Would require fetching all vaults and looking through them to see if it exists
                domainName           = $domainName
                customSecurityEntity = @{
                    allowDragAndDrop = $allowDragAndDrop
                    canImport        = $canImport
                    canExport        = $canExport
                    offlineMode      = $offlineMode
                    denyAddInRoot    = $denyAddInRoot
                }
            }
        }

        $newRoleData.userSecurity.authenticationType = switch ($AuthenticationType) {
            ([ServerUserType]::Builtin) { 0 }
           ([ServerUserType]::Domain) { 3 }
           ([ServerUserType]::AzureAD) { 8 }
        }

        $params = @{
            Uri    = $URI
            Method = 'PUT'
            Body   = (ConvertTo-Json $newRoleData)
        }

        $res = Invoke-DS @params
        return $res
    }

    END {
        $res.isSuccess ? (Write-Verbose '[New-DSRole] Completed Successfully.') : (Write-Verbose '[New-DSRole] Ended with errors...')
    }    
}