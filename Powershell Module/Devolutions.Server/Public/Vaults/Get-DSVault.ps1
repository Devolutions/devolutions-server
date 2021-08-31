function Get-DSVault {
    <#
        .SYNOPSIS
        Gets a specific vault or a collection of vaults.

        .DESCRIPTION
        By default, this will return the first page containing the 25 first vaults in your Devolutions Server. You can
        specify if you want only one vault by ID, all of your vaults or you can also specify a page size and a page number
        to get paginated results.

        .EXAMPLE
        > Get-DSVault

        [ServerResponse]::@{
            ...
            Body = @{
                currentPage = 1
                data = [object[]] #Vaults are stored in here
                pageSize = 25
                totalCount = 100
                totalPage = 3
            }
        }

        .EXAMPLE
        > Get-DSVault -All

        [ServerResponse]::@{
            ...
            Body = [object[]] #Vaults are stored in here
        }

        .EXAMPLE
        > Get-DSVault -PageNumber 1 -PageSize 1

        [ServerResponse]::@{
            ...
            Body = @{
                currentPage = 1
                data = [object[]] #Vaults are stored in here
                pageSize = 1
                totalCount = 100
                totalPage = 100
            }
        }
    #>
    [CmdletBinding(DefaultParameterSetName = 'GetPage')]
    param(		
        [Parameter(ParameterSetName = 'GetOne')]	
        [guid]$VaultID, #= $(throw 'Vault ID cannot be null or empty. Please provide a valid vault ID or use the -All parameter.'), *Cant seem to be able to use this sort of validation when using parameters set*
        [Parameter(ParameterSetName = 'GetAll')]	
        [switch]$All,
        [Parameter(ParameterSetName = 'GetPage')]
        [int]$PageSize = 25,
        [Parameter(ParameterSetName = 'GetPage')]
        [int]$PageNumber = 1
    )
        
    BEGIN {
        Write-Verbose '[Get-DSVault] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $RequestParams = @{
            Uri    = ''
            Method = 'GET'
        }

        switch ($PSCmdlet.ParameterSetName) {
            'GetOne' { 
                $RequestParams.Uri = "$Script:DSBaseURI/api/security/repositories/$VaultID"

                try { $res = Invoke-DS @RequestParams }
                catch { Write-Error $_.ErrorDetails.Message }
            }

            'GetAll' {
                $RequestParams.Uri = "$Script:DSBaseURI/api/v3/vaults?pagesize=100"
                $AllVaults = @()

                try {
                    $res = Invoke-DS @RequestParams
                    
                    if ($res.isSuccess) {
                        $AllVaults += $res.Body.data

                        for ($Page = 2; $Page -le $res.Body.totalPage; $Page++) {
                            $RequestParams.Uri = "$Script:DSBaseURI/api/v3/vaults?pagesize=100&pagenumber=$Page"
                            $res = Invoke-DS @RequestParams
                            $AllVaults += if ($res.isSuccess) { $res.Body.data }
                        }

                        $res.Body = [PSCustomObject]@{
                            data = $AllVaults
                        }
                        $res.originalResponse = $null
                    }
                }
                catch {
                    Write-Error $_.ErrorDetails.Message
                }
            }

            'GetPage' {
                $RequestParams.Uri = "$Script:DSBaseURI/api/v3/vaults?pagenumber=$PageNumber&pagesize=$PageSize"

                $res = Invoke-DS @RequestParams
            }
        }

        return $res
    }
    
    END {
        If ($res.isSuccess) {
            Write-Verbose '[Get-DSVault] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSVault] ended with errors...'
        }
    }
}