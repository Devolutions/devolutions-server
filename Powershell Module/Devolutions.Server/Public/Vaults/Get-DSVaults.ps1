function Get-DSVaults {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    param(			
        [ValidateSet('Name', 'Description')]
        [string]$SortField = '',
        [System.Management.Automation.SwitchParameter]$Descending,
        [int]$PageNumber = 1,
        [int]$PageSize = 100,
        [Switch]$Legacy 
    )
        
    BEGIN {
        Write-Verbose '[Get-DSVaults] Beginning...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        [System.Collections.ArrayList]$Vaults = @()
        [ServerResponse]$response = $null

        $LegacyRequested = $Legacy.IsPresent
        $PSBoundParameters.Remove('Legacy') | out-null

        if (!$PSBoundParameters.PageNumber) { $PSBoundParameters.Add('PageNumber', $PageNumber) }
        if (!$PSBoundParameters.PageSize) { $PSBoundParameters.Add('PageSize', $PageSize) }

        [System.Version]$ModernVersion = '2020.3.8.0'
        [System.Version]$v = $Global:DSInstanceVersion
            
        if (($LegacyRequested) -or ($v.CompareTo($ModernVersion) -lt 0)) {
            do {
                $response = Get-DSVaultsLegacy @PSBoundParameters
                $response.Body.data | ForEach-Object {
                    $Vaults += $_
                }
                $PageNumber++
            } while ($PageNumber -le $response.Body.totalPage)    
        }
        else {
            do {
                $response = Get-DSVaultsModern @PSBoundParameters
                $response.Body.data | ForEach-Object {
                    $Vaults += $_
                }
                $PageNumber++
                $PSBoundParameters.PageNumber++
            } while ($PageNumber -le $response.Body.totalPage)
        }

        $response.Body.data = $Vaults
        $response.Body.PSObject.Properties.Remove('currentPage')
        $response.Body.PSObject.Properties.Remove('pageSize')
        $response.Body.PSObject.Properties.Remove('totalCount')
        $response.Body.PSObject.Properties.Remove('totalPage')
        return $response
    }
    
    END {
        If ($response.isSuccess) {
            Write-Verbose '[Get-DSVaults] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSVaults] Ended with errors...'
        }
    }
}