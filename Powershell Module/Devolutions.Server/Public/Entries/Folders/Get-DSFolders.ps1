function Get-DSFolders {
    <#
        .SYNOPSIS
        Returns all folders at vault's root.
        .DESCRIPTION
        By default, returns only the vault's root folders. This is by design, as to prevent massive compute charge for customers with thousands of entries in their vaults. To get all folders, regardless of how deep they are, use -IncludeSubFolders.
        .EXAMPLE
        > Get-DSFolders -VaultID "Your [guid] here"

        .EXAMPLE
        > Get-DSFolders -VaultID "Your [guid] here" -IncludeSubFolders
    #>
    [CmdletBinding()]
    param(			
        [ValidateNotNullOrEmpty()]
        [string]$VaultId,
        #TODO:improve to allow for a folder to start from
        [switch]$IncludeSubFolders
    )
        
    BEGIN {
        Write-Verbose '[Get-DSFolders] Beginning...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $response = Get-DSEntriesTree @PSBoundParameters
        if ($response.IsSuccess) {
            if ($IncludeSubFolders.IsPresent) {
                throw 'Assertion : NotImplementedException'
            }
            else {
                $toplevelFolders = $response.Body.Data | where-object { $_.connectionType -eq 25 }
                $response.Body.Data = [PSCustomObject]@($toplevelFolders)
            }
        }
        return $response
    }
    
    END {
        Write-Verbose '[Get-DSFolders] ...end'
    }
}