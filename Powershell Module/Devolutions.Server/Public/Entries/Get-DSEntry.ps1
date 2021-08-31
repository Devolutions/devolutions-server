function Get-DSEntry {
    <#
        .SYNOPSIS
        Return a single entry by ID
        .EXAMPLE
        > Get-DSEntry -EntryId "[guid]"
    #>
    [CmdletBinding(DefaultParameterSetName = 'GetPage')]
    PARAM (
        [guid]$VaultID = ([guid]::Empty),
        [switch]$SearchAllVaults,
        
        [Parameter(ParameterSetName = 'GetById')]
        [guid]$EntryId,
        [Parameter(ParameterSetName = 'GetById')]
        [switch]$AsRDMConnection,

        [Parameter(ParameterSetName = 'Filter')]
        [string]$FilterValue,
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
        Write-Verbose '[Get-DSEntry] Beginning...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        [ServerResponse]$response = Get-DSEntryLegacy @PSBoundParameters
        return $response
    }
    
    END {
        If ($response.isSuccess) {
            Write-Verbose '[Get-DSEntry] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSEntry] ended with errors...'
        }
    }
}

function GetById {
    param(
        [guid]$EntryId
    )

    $RequestParams = @{
        Uri    = $null
        Method = 'GET'
    }

    $RequestParams.Uri = $AsRDMConnection ? ("$Script:DSBaseURI/api/connections/$EntryId") : ("$Script:DSBaseURI/api/connections/partial/$EntryId")

    return Invoke-DS @RequestParams
}

function GetByFilter {
    param (
        [guid]$VaultID,
        [string]$FilterValue,
        [SearchItemType]$FilterBy
    )

    if ($SearchAllVaults) {
        $VaultIDs = ($res = Get-DSVault -All).isSuccess ? ($res.Body.data | Select-Object -ExpandProperty id) : (throw 'error no vaults found')

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