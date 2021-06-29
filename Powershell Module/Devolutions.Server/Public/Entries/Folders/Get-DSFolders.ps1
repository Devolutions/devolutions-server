function Get-DSFolders {
    <#
    .SYNOPSIS
    Gets all folders for a given vault.
    .DESCRIPTION
    Gets all folders for a given vaults and include all subfolders if 'IncludeSubFolders' flag is present.
    .EXAMPLE
    Return all folders in default vault
    > Get-DSFolders -VaultId '00000000-0000-0000-0000-000000000000'
    .EXAMPLE
    Return all folders and subfolders in default vault
    > Get-DSFolders -VaultId '00000000-0000-0000-0000-000000000000' -IncludeSubFolders
    #>
    [CmdletBinding()]
    param(			
        [guid]$VaultId,
        [switch]$IncludeSubFolders
    )
        
    BEGIN {
        Write-Verbose '[Get-DSFolders] begin...'
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        [array]$AllFolders = @()

        $Params = @{
            URI    = "$Script:DSBaseURI/api/connections/partial/tree/$($VaultId)"
            Method = 'GET'
        }

        try {
            if (($res = Invoke-DS @Params).isSuccess) {
                $Root = $res.Body.data
                $AllFolders += $Root
                $AllFolders += $Root.partialConnections | Where-Object { $_.connectionType -eq [ConnectionType]::Group }

                if ($IncludeSubFolders) {
                    $Root.partialConnections | ForEach-Object {
                        $AllFolders += Get-DSFoldersRecurivse $_
                    }
                }
            } 
        }
        catch {
            Write-Error $_.Exception.Message
        }

        $res.Body.data = $AllFolders
        return $res
    }
    
    END {
        Write-Verbose '[Get-DSFolders] ...end'
    }
}