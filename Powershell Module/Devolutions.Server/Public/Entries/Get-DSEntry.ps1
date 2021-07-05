function Get-DSEntry {
    [CmdletBinding(DefaultParameterSetName = 'GetAll')]
    PARAM (
        [guid]$VaultID = ([guid]::Empty),

        [Parameter(ParameterSetName = 'GetByName')]
        [string]$EntryName,
        [Parameter(ParameterSetName = 'GetByName')]
        [switch]$SearchAllVaults,

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
        switch ($PSCmdlet.ParameterSetName) {
            'GetAll' { 
                $Entries = GetAll $VaultID
                $res = [ServerResponse]::new($true, $null, [PSCustomObject]@{ data = $Entries }, $null, $null, 200)
            }

            'GetByName' {
                $Entry = $SearchAllVaults ? (GetByName -EntryName $EntryName) : (GetByName $VaultID $EntryName)
            }

            'GetPage' {

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

function GetByName {
    param (
        [guid]$VaultID,
        [string]$EntryName
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
                        searchItemType = 12
                        value          = $EntryName
                    }
                )
                includePrivateVault = $true
            }
        } | ConvertTo-Json -Depth 3

        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/connections/partial/multivault"
            Method = 'POST'
            Body   = $Body
        }

        $res = Invoke-DS @RequestParams
        $res
    }
    else {
        
    }
}

<#
function Get-DSEntry {
    
        .SYNOPSIS
        Return a single entry by ID
        .EXAMPLE
        > Get-DSEntry -EntryId "[guid]"
    
        [CmdletBinding()]
        param(			
            [ValidateNotNullOrEmpty()]
            [GUID]$EntryId,
            #Used to know if advanced properties should be included
            [switch]$IncludeAdvancedProperties
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
#>