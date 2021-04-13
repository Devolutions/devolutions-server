function Get-DSPamFolder {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
    [CmdletBinding()]
    param(		
        [ValidateNotNullOrEmpty()]
        [guid]$candidFolderID
    )
        
    BEGIN {
        Write-Verbose '[Get-DSPamFolder] begin...'
    
        $URI = "$Script:DSBaseURI/api/pam/folders?folderID=$candidFolderID"

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {   	
            $params = @{
                Uri    = $URI
                Method = 'GET'
            }

            $res = Invoke-DS @params -Verbose
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
        If ($res.isSuccess) {
            Write-Verbose '[Get-DSPamFolders] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSPamFolders] ended with errors...'
        }
    }
}