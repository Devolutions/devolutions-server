function Get-DSEntry {
    <#
        .SYNOPSIS
        Get entry(ies) from your Devolutions Server instance.
        .DESCRIPTION
        Using different parameter sets, returns either all entries (from one or all vaults), a specific entry by filter (Get-Help Get-DSEntry -Parameter FilterBy) or paginated results.
        .EXAMPLE
        > Get-DSEntry
        [ServerResponse]@{
            ...
            Body = @{
                data = @({Entry1}, {Entry2}, ...)
                additionalData = ...
                pageSize = [int]
                pageNumber = [int]
                totalPages = [int]
            }
        }

        .EXAMPLE
        > Get-DSEntry $All

        [ServerResponse]@{
            data = @({Entry1}, {Entry2}, ...)
        }

        .EXAMPLE
        > Get-DSEntry -FilterValue 'Entry1' -SearchAllVaults -FilterBy Name

        [ServerResponse]@{
            ...
            Body = @{
                data = @({Entry1}, {Entry2}, ...)                
                result = [SaveResult]
            }
        }
    
    #>
    [CmdletBinding(DefaultParameterSetName = 'GetPage')]
    PARAM (
        [guid]$VaultID = ([guid]::Empty),

        [Parameter(ParameterSetName = 'Filter')]
        [string]$FilterValue,
        [Parameter(ParameterSetName = 'Filter')]
        [switch]$SearchAllVaults,
        [Parameter(ParameterSetName = 'Filter')]
        [ValidateSet('Name', 'Username', 'Folder', 'Description', 'Tag', ErrorMessage = 'Filtering by {0} is not yet supported. Please use one of the following filters: {1}')]
        [SearchItemType]$FilterBy = [SearchItemType]::Name,

        [Parameter(ParameterSetName = 'GetPage')]
        [int]$PageSize = 25,
        [Parameter(ParameterSetName = 'GetPage')]
        [int]$PageNumber = 1,

        [Parameter(ParameterSetName = 'GetAll')]
        [switch]$All
    )
    
    BEGIN {
        Write-Verbose '[Get-DSVault] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $res = switch ($PSCmdlet.ParameterSetName) {
            'GetAll' { 
                $Entries = GetAll $VaultID | Out-Null
                [ServerResponse]::new($true, $null, [PSCustomObject]@{ data = $Entries }, $null, $null, 200)
            }

            'Filter' {
                $SearchAllVaults ? (GetByFilter -FilterValue $FilterValue -FilterBy $FilterBy) : (GetByFilter -VaultID $VaultID -FilterValue $FilterValue -FilterBy $FilterBy)
            }

            'GetPage' {
                GetPage -VaultID $VaultID -PageNumber $PageNumber -PageSize $PageSize
            }
        }

        return $res
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Get-DSEntry] Completed successfully!') : (Write-Verbose '[Get-DSEntry] Ended with errors...')
    }
}

function GetAll {
    param (
        [guid]$VaultID
    )
    $Entries = @() 
    $Folders = ($res = Get-DSFolders $VaultID -IncludeSubFolders).isSuccess ? ($res.Body.data) : (throw 'Could not fetch the list of folders for this vault. Please make sure you have a valid vault ID.')

    $Folders | ForEach-Object {
        $_.partialConnections | ForEach-Object {
            if (($null -ne $_) -and ($_.connectionType -ne [ConnectionType]::Group)) { $Entries += $_ }
        }
    }

    return $Entries
}

function GetByFilter {
    param (
        [guid]$VaultID,
        [string]$FilterValue,
        [SearchItemType]$FilterBy
    )

    if ($SearchAllVaults) {
        $VaultIDs = ($res = Get-DSVault -All).isSuccess ? ($res.Body.data | Select-Object -ExpandProperty id) : $null

        if (!$VaultIDs) {
            throw 'error no vaults found'
        }

        $Body = @{
            repositoryIds    = $VaultIDs
            searchParameters = @{
                data                = @(
                    @{
                        searchItemType = $FilterBy
                        value          = $FilterValue
                    }
                )
                includePrivateVault = $true
            }
        } | ConvertTo-Json -Depth 3
    }
    else {
        $Body = @{
            repositoryIds    = @($VaultID)
            searchParameters = @{
                data                = @(
                    @{
                        searchItemType = $FilterBy
                        value          = $FilterValue
                    }
                )
                includePrivateVault = $false
            }
        } | ConvertTo-Json -Depth 3
    }

    $RequestParams = @{
        URI    = "$Script:DSBaseURI/api/connections/partial/multivault"
        Method = 'POST'
        Body   = $Body
    }

    return Invoke-DS @RequestParams
}

function GetPage {
    Param(
        [guid]$VaultID,
        [int]$PageNumber,
        [int]$PageSize
    )

    $RequestParams = @{
        URI    = "$Script:DSBaseURI/api/v3/entries?vaultid=$VaultID&pagenumber=$PageNumber&pagesize=$PageSize"
        Method = 'GET'
    }

    return Invoke-DS @RequestParams
}