function Get-DSPamFolder {
    [CmdletBinding(DefaultParameterSetName = 'GetById')]
    param(		
        [parameter(ParameterSetName = 'GetById')]
        [guid]$FolderID,
        [parameter(ParameterSetName = 'GetRoot')]
        [switch]$Root
    )
        
    BEGIN {
        Write-Verbose '[Get-DSPamFolder] Beginning...'
    
        $URI = $Root ? "$Script:DSBaseURI/api/pam/folders?folderID=null" : "$Script:DSBaseURI/api/pam/folders/$FolderID"

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        try {   	
            $RequestParams = @{
                Uri    = $URI
                Method = 'GET'
            }

            $res = Invoke-DS @RequestParams -Verbose
            return $res
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
    }
    
    END {
        $res.isSuccess ? (Write-Verbose '[Get-DSPamFolders] Completed Successfully.') : (Write-Verbose '[Get-DSPamFolders] ended with errors...')
    }
}