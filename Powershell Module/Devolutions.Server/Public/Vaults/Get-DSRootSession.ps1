function Get-DSRootSession {
    [CmdletBinding()]
    param (
        [string]$VaultID = $(throw 'VaultID is null. Please provide a valid vault ID and try again.')
    )
    
    begin {
        Write-Verbose '[Get-DSRootSession] Beginning...'
    
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    process {
        $root = (Get-DSFolders ($vaultID)).Body.data | Where-Object { $_.connectionType -eq 92 }
        return $root
    }
    
    end {
        Write-Verbose ($root ? '[Get-DSRootSession] Completed Successfully.' : '[Get-DSRootSession] ended with errors...')
    }
}